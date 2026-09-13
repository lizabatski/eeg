"""NeuroLoop: predict attention lapses from pre-stimulus EEG.

Team: Monster's Inc

Algorithm basis
---------------
This supervised classifier tests whether spectral EEG features before a
Flanker stimulus contain information about the subsequent behavioral response.
Alpha/theta contrasts motivate the feature set as candidate attention markers;
they are not direct measurements of stress or cognitive capacity. Logistic
regression provides a small, interpretable baseline with learned feature weights.

Data and preprocessing
----------------------
The source is the COG-BCI v4 Flanker dataset (Zenodo record 7413650). The current
saved cohort comprises participants 1-11 and 16: 36 sessions, 4,320 trials before
screening and 2,830 retained trials. Each trial contributes the 1.5 seconds
immediately before stimulus onset. Shared helpers in live_model.py apply a
causal 1-40 Hz Butterworth bandpass to Fz, P3, Pz, P4, Oz, O1 and O2. Windows
with nonfinite values or channel peak-to-peak amplitude above 150 microvolts
are rejected. Accepted windows are resampled to 250 Hz for feature extraction.

Welch spectral estimates yield log10 relative theta, alpha, lower-alpha,
upper-alpha and beta power in frontal and posterior regions (ten features).
Posterior log-alpha minus frontal log-theta supplies the eleventh feature.
Offline and live inference use the same feature implementation and ordering.

Labels, learning and evaluation
-------------------------------
A lapse is an incorrect/missed response or a correct response slower than
the participant's 75th-percentile correct-response reaction time. That threshold
is computed from retained trials across the participant's sessions; it is a
retrospective evaluation label, not a prospectively calibrated personal cutoff.

For each held-out participant, StandardScaler and class-balanced logistic
regression are fitted exclusively on the other participants. The classifier
uses p = 1 / (1 + exp(-(intercept + weights @ standardized_features))).
Weights are learned with scikit-learn's regularized logistic regression;
class balancing compensates for unequal lapse/non-lapse counts. Scores are
not independently probability-calibrated. A 0.5 threshold is used for reported
accuracy, while AUROC evaluates ranking across thresholds.

Leave-one-participant-out validation keeps all sessions of the test participant
out of model fitting. Reported mean AUROC weights each participant equally.
The 12-participant run obtained mean AUROC 0.5017: approximately chance, without
established predictive utility. After evaluation, a fresh model is fitted on
all selected participants for experimental deployment. Training-set scaling
stays fixed at inference; this classifier does not use resting-baseline z-scores.

Run from the repository root (requires the project dependencies and dataset):
    python scripts/12_train_cogbci_flanker.py --subjects 1 2 3 4 5 6 7 8 9 10 11 16

This module contains the training algorithm and imports shared DSP/model helpers
from neuroloop.live_model and neuroloop.features; it is not a standalone bundle.
"""
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
    """One accepted pre-stimulus feature vector and its behavioral outcome."""
    subject: int
    session: str
    vector: np.ndarray
    incorrect: bool
    reaction_time_s: float | None


def flanker_outcomes(
    events: Iterable[tuple[float, str]],
) -> list[tuple[float, bool, float | None]]:
    """Pair each stimulus with its first response before the next trial.

    Codes 241/242 identify stimuli, 2511/2512 correct responses, and 2521/2522
    incorrect responses. Missing responses count as lapses. Times are seconds;
    reaction time is response onset minus stimulus onset.
    """
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
    """Read one EEGLAB session and extract clean pre-stimulus examples.

    Require 120 stimuli and the seven deployment channels. Causal filtering
    prevents future EEG samples from contributing to pre-stimulus features.
    Artifact screening and feature extraction reuse the live pipeline helpers.
    """
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
    """Return features, binary lapse labels and the subject's RT cutoff.

    Only retained correct-response trials determine the 75th percentile.
    Incorrect and missing responses are positive regardless of reaction time.
    """
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
    """Evaluate on unseen participants, then fit the final deployment model.

    Args:
        data_root: Directory containing extracted sub-*/ses-S*/eeg/Flanker.set.
        subjects: Optional participant IDs; each must have all three sessions.
            If omitted, use every locally extracted session.

    Returns:
        Model with a fitted scaler/classifier, preprocessing metadata and
        per-participant held-out metrics. The final pooled fit is not used to
        calculate the held-out scores.

    Raises:
        FileNotFoundError: No Flanker sessions are available.
        ValueError: Requested sessions, channels or usable labels are missing,
            or fewer than two participants are available for validation.
    """
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
