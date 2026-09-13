"""Train the deployment model from verified COG-BCI Flanker recordings."""
from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path
from typing import Iterable
import warnings

import mne
import numpy as np
from sklearn.metrics import accuracy_score, roc_auc_score

from .live_model import (
    ARTIFACT_THRESHOLD_VOLTS,
    FILTER_BAND_HZ,
    FILTER_ORDER,
    MODEL_CHANNELS,
    MODEL_FEATURES,
    TARGET_SAMPLE_RATE_HZ,
    WINDOW_SECONDS,
    CausalBandpass,
    DeploymentModel,
    build_pipeline,
    extract_model_vector,
    require_model_channels,
    window_is_clean,
)


COGBCI_MODEL_ID = "cogbci-flanker-lapse-ant-v1"
STIMULUS_CODES = {"241", "242"}
CORRECT_RESPONSE_CODES = {"2511", "2512"}
INCORRECT_RESPONSE_CODES = {"2521", "2522"}
RESPONSE_CODES = CORRECT_RESPONSE_CODES | INCORRECT_RESPONSE_CODES


@dataclass(frozen=True)
class FlankerWindow:
    subject: int
    session: str
    vector: np.ndarray
    incorrect: bool
    reaction_time_s: float | None


def flanker_outcomes(
    events: Iterable[tuple[float, str]],
) -> list[tuple[float, bool, float | None]]:
    """Return stimulus onset, incorrect flag, and reaction time."""
    ordered = sorted(
        ((float(onset), str(code)) for onset, code in events),
        key=lambda event: event[0],
    )
    outcomes: list[tuple[float, bool, float | None]] = []
    for index, (onset, code) in enumerate(ordered):
        if code not in STIMULUS_CODES:
            continue
        next_trial = next(
            (
                later_onset
                for later_onset, later_code in ordered[index + 1 :]
                if later_code == "210" or later_code in STIMULUS_CODES
            ),
            float("inf"),
        )
        response = next(
            (
                (response_onset, response_code)
                for response_onset, response_code in ordered[index + 1 :]
                if response_onset < next_trial and response_code in RESPONSE_CODES
            ),
            None,
        )
        if response is None:
            outcomes.append((onset, True, None))
            continue
        response_onset, response_code = response
        outcomes.append(
            (
                onset,
                response_code in INCORRECT_RESPONSE_CODES,
                response_onset - onset,
            )
        )
    return outcomes


def load_flanker_session(
    set_path: str | Path,
    *,
    subject: int,
) -> list[FlankerWindow]:
    path = Path(set_path)
    with warnings.catch_warnings():
        warnings.filterwarnings("ignore", message="Limited .* annotation")
        warnings.filterwarnings("ignore", message="The data contains 'boundary'")
        warnings.filterwarnings("ignore", message="Not setting position of .* ecg")
        raw = mne.io.read_raw_eeglab(str(path), preload=True, verbose=False)
    try:
        picks = require_model_channels(raw.ch_names)
        sample_rate = float(raw.info["sfreq"])
        filtered = CausalBandpass(sample_rate, len(MODEL_CHANNELS)).process(
            raw.get_data(picks=list(picks))
        )
        events = zip(raw.annotations.onset, raw.annotations.description)
        outcomes = flanker_outcomes(events)
        if len(outcomes) != 120:
            raise ValueError(
                f"{path} contains {len(outcomes)} Flanker stimuli; expected 120"
            )
        rows: list[FlankerWindow] = []
        for onset, incorrect, reaction_time in outcomes:
            stop = round(onset * sample_rate)
            start = stop - round(WINDOW_SECONDS * sample_rate)
            if start < 0 or stop > filtered.shape[1]:
                continue
            window = filtered[:, start:stop]
            if not window_is_clean(window):
                continue
            rows.append(
                FlankerWindow(
                    subject=subject,
                    session=path.parents[1].name,
                    vector=extract_model_vector(window, sample_rate),
                    incorrect=incorrect,
                    reaction_time_s=reaction_time,
                )
            )
        return rows
    finally:
        raw.close()


def _subject_arrays(
    rows: list[FlankerWindow],
) -> tuple[np.ndarray, np.ndarray, float]:
    correct_reaction_times = [
        row.reaction_time_s
        for row in rows
        if not row.incorrect and row.reaction_time_s is not None
    ]
    if not correct_reaction_times:
        raise ValueError("Subject has no correct Flanker reaction times")
    threshold = float(np.percentile(correct_reaction_times, 75))
    labels = np.asarray(
        [
            row.incorrect
            or row.reaction_time_s is None
            or row.reaction_time_s > threshold
            for row in rows
        ],
        dtype=int,
    )
    return np.vstack([row.vector for row in rows]), labels, threshold


def train_cogbci_model(
    data_root: str | Path,
    *,
    subjects: Iterable[int] | None = None,
) -> DeploymentModel:
    root = Path(data_root)
    set_files = sorted(root.glob("sub-*/ses-S*/eeg/Flanker.set"))
    if subjects is not None:
        requested = set(subjects)
        if len(requested) < 2:
            raise ValueError("Select at least two subjects")
        set_files = [p for p in set_files if int(p.parents[2].name[4:]) in requested]
        for subject in requested:
            sessions = {p.parents[1].name for p in set_files if p.parents[2].name == f"sub-{subject:02}"}
            if sessions != {"ses-S1", "ses-S2", "ses-S3"}:
                raise ValueError(f"Subject {subject} requires all three sessions")
    if not set_files:
        raise FileNotFoundError(f"No extracted COG-BCI Flanker sessions in {root}")
    by_subject: dict[int, list[FlankerWindow]] = {}
    for set_file in set_files:
        subject_part = next(
            part for part in set_file.parts if part.startswith("sub-")
        )
        subject = int(subject_part.removeprefix("sub-"))
        by_subject.setdefault(subject, []).extend(
            load_flanker_session(set_file, subject=subject)
        )
    if len(by_subject) < 2:
        raise ValueError(
            "At least two extracted COG-BCI subjects are required for evaluation"
        )

    arrays = {
        subject: _subject_arrays(rows)
        for subject, rows in by_subject.items()
    }
    held_out_results = []
    for held_out, (test_x, test_y, rt_threshold) in arrays.items():
        train = [values for subject, values in arrays.items() if subject != held_out]
        train_x = np.vstack([values[0] for values in train])
        train_y = np.concatenate([values[1] for values in train])
        pipeline = build_pipeline().fit(train_x, train_y)
        probability = pipeline.predict_proba(test_x)[:, 1]
        held_out_results.append(
            {
                "held_out_subject": held_out,
                "n": int(len(test_y)),
                "lapses": int(test_y.sum()),
                "reaction_time_75th_percentile_s": rt_threshold,
                "auc": float(roc_auc_score(test_y, probability)),
                "accuracy_at_0_5": float(
                    accuracy_score(test_y, probability >= 0.5)
                ),
            }
        )

    all_x = np.vstack([values[0] for values in arrays.values()])
    all_y = np.concatenate([values[1] for values in arrays.values()])
    evaluation = {
        "strategy": "leave-one-subject-out",
        "subjects": held_out_results,
        "mean_auc": float(
            np.mean([result["auc"] for result in held_out_results])
        ),
        "training_subjects": sorted(arrays),
        "training_sessions": len(set_files),
        "available_trials": 120 * len(set_files),
        "retained_trials_by_subject": {
            str(subject): len(rows) for subject, rows in by_subject.items()
        },
        "pooled_training_trials": int(len(all_y)),
        "pooled_training_lapses": int(all_y.sum()),
        "lapse_definition": (
            "incorrect or missed response, or correct-response RT above the "
            "subject's 75th percentile"
        ),
    }
    return DeploymentModel(
        model_id=COGBCI_MODEL_ID,
        pipeline=build_pipeline().fit(all_x, all_y),
        channels=MODEL_CHANNELS,
        feature_names=MODEL_FEATURES,
        window_seconds=WINDOW_SECONDS,
        target_sample_rate_hz=TARGET_SAMPLE_RATE_HZ,
        filter_band_hz=FILTER_BAND_HZ,
        filter_order=FILTER_ORDER,
        artifact_threshold_volts=ARTIFACT_THRESHOLD_VOLTS,
        label="cogbci_flanker_lapse",
        evaluation=evaluation,
    )
