"""Deployment-compatible Flip Cup model training and live feature extraction."""
from __future__ import annotations

from dataclasses import dataclass
from fractions import Fraction
import json
import math
from pathlib import Path
from typing import Any, Mapping

import joblib
import mne
import numpy as np
import scipy
import sklearn
from scipy.signal import butter, resample_poly, sosfilt, sosfilt_zi
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score, roc_auc_score
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import StandardScaler

from .features import extract_features, features_to_vector


MODEL_ID = "flipcup-causal-ant-v1"
MODEL_CHANNELS = ("Fz", "P3", "Pz", "P4", "Oz", "O1", "O2")
MODEL_FEATURES = (
    "theta_frontal",
    "theta_posterior",
    "alpha_frontal",
    "alpha_posterior",
    "alpha_low_frontal",
    "alpha_low_posterior",
    "alpha_high_frontal",
    "alpha_high_posterior",
    "beta_frontal",
    "beta_posterior",
    "ratio_alpha_theta",
)
FILTER_BAND_HZ = (1.0, 40.0)
FILTER_ORDER = 4
WINDOW_SECONDS = 1.5
TARGET_SAMPLE_RATE_HZ = 250.0
ARTIFACT_THRESHOLD_VOLTS = 150e-6
UPDATE_SECONDS = 0.5


@dataclass
class DeploymentModel:
    model_id: str
    pipeline: Pipeline
    channels: tuple[str, ...]
    feature_names: tuple[str, ...]
    window_seconds: float
    target_sample_rate_hz: float
    filter_band_hz: tuple[float, float]
    filter_order: int
    artifact_threshold_volts: float
    label: str
    evaluation: dict[str, Any]

    def predict_failure_probability(self, vector: np.ndarray) -> float:
        values = np.asarray(vector, dtype=float).reshape(1, -1)
        if values.shape[1] != len(self.feature_names):
            raise ValueError(
                f"Model expects {len(self.feature_names)} features, "
                f"received {values.shape[1]}"
            )
        probability = float(self.pipeline.predict_proba(values)[0, 1])
        if not math.isfinite(probability):
            raise ValueError("Model produced a non-finite probability")
        return probability

    def manifest(self) -> dict[str, Any]:
        return {
            "model_id": self.model_id,
            "channels": list(self.channels),
            "feature_names": list(self.feature_names),
            "window_seconds": self.window_seconds,
            "target_sample_rate_hz": self.target_sample_rate_hz,
            "filter_band_hz": list(self.filter_band_hz),
            "filter_order": self.filter_order,
            "artifact_threshold_microvolts": (
                self.artifact_threshold_volts * 1e6
            ),
            "label": self.label,
            "evaluation": self.evaluation,
            "software": {
                "numpy": np.__version__,
                "scipy": scipy.__version__,
                "scikit_learn": sklearn.__version__,
                "mne": mne.__version__,
                "joblib": joblib.__version__,
            },
            "warning": (
                "Experimental demonstration model. Held-out evaluation did not "
                "establish prediction above chance and this is not a validated "
                "cognitive-load measure."
            ),
        }


class CausalBandpass:
    """Stateful causal filter shared by offline training and live inference."""

    def __init__(self, sample_rate_hz: float, channel_count: int) -> None:
        if sample_rate_hz <= 2 * FILTER_BAND_HZ[1]:
            raise ValueError("Sample rate is too low for the 1-40 Hz filter")
        if channel_count <= 0:
            raise ValueError("Causal filter requires at least one channel")
        self.sample_rate_hz = float(sample_rate_hz)
        self.channel_count = channel_count
        self.sos = butter(
            FILTER_ORDER,
            FILTER_BAND_HZ,
            btype="bandpass",
            fs=self.sample_rate_hz,
            output="sos",
        )
        self._zi: np.ndarray | None = None

    def process(self, values: np.ndarray) -> np.ndarray:
        data = np.asarray(values, dtype=float)
        if data.ndim != 2 or data.shape[0] != self.channel_count:
            raise ValueError(
                f"Expected ({self.channel_count}, samples) EEG array, "
                f"received {data.shape}"
            )
        if data.shape[1] == 0:
            return data.copy()
        if not np.all(np.isfinite(data)):
            raise ValueError("EEG data contains a non-finite value")
        if self._zi is None:
            base = sosfilt_zi(self.sos)
            self._zi = (
                base[:, np.newaxis, :]
                * data[np.newaxis, :, 0, np.newaxis]
            )
        filtered, self._zi = sosfilt(
            self.sos,
            data,
            axis=1,
            zi=self._zi,
        )
        return filtered


def require_model_channels(channel_names: list[str] | tuple[str, ...]) -> tuple[int, ...]:
    lookup = {name.upper(): index for index, name in enumerate(channel_names)}
    missing = [name for name in MODEL_CHANNELS if name.upper() not in lookup]
    if missing:
        raise ValueError(
            "Live classifier requires channels: "
            + ", ".join(MODEL_CHANNELS)
            + "; missing: "
            + ", ".join(missing)
        )
    return tuple(lookup[name.upper()] for name in MODEL_CHANNELS)


def resample_model_window(
    window_volts: np.ndarray,
    sample_rate_hz: float,
) -> np.ndarray:
    ratio = Fraction(TARGET_SAMPLE_RATE_HZ / float(sample_rate_hz)).limit_denominator(
        10_000
    )
    if ratio.numerator == ratio.denominator:
        return np.asarray(window_volts, dtype=float)
    return resample_poly(
        np.asarray(window_volts, dtype=float),
        ratio.numerator,
        ratio.denominator,
        axis=1,
    )


def window_is_clean(window_volts: np.ndarray) -> bool:
    data = np.asarray(window_volts, dtype=float)
    return bool(
        data.ndim == 2
        and data.shape[0] == len(MODEL_CHANNELS)
        and np.all(np.isfinite(data))
        and np.all(np.ptp(data, axis=1) <= ARTIFACT_THRESHOLD_VOLTS)
    )


def extract_model_vector(
    filtered_window_volts: np.ndarray,
    sample_rate_hz: float,
) -> np.ndarray:
    data = np.asarray(filtered_window_volts, dtype=float)
    if data.ndim != 2 or data.shape[0] != len(MODEL_CHANNELS):
        raise ValueError(
            f"Model window must have {len(MODEL_CHANNELS)} channels"
        )
    resampled = resample_model_window(data, sample_rate_hz)
    expected_samples = round(WINDOW_SECONDS * TARGET_SAMPLE_RATE_HZ)
    if abs(resampled.shape[1] - expected_samples) > 1:
        raise ValueError(
            f"Model window must span {WINDOW_SECONDS} seconds; "
            f"received {resampled.shape[1]} samples at "
            f"{TARGET_SAMPLE_RATE_HZ:g} Hz"
        )
    feats = extract_features(
        resampled,
        TARGET_SAMPLE_RATE_HZ,
        list(MODEL_CHANNELS),
    )
    vector = features_to_vector(feats, list(MODEL_FEATURES))
    if not np.all(np.isfinite(vector)):
        raise ValueError("Model feature vector contains a non-finite value")
    return vector


def build_pipeline() -> Pipeline:
    return Pipeline(
        [
            ("scale", StandardScaler()),
            (
                "clf",
                LogisticRegression(
                    max_iter=2000,
                    class_weight="balanced",
                    random_state=0,
                ),
            ),
        ]
    )


def load_training_session(path: str | Path) -> tuple[np.ndarray, np.ndarray]:
    raw = mne.io.read_raw_ant(str(path), preload=True, verbose=False)
    try:
        picks = require_model_channels(raw.ch_names)
        sample_rate = float(raw.info["sfreq"])
        unfiltered = raw.get_data(picks=list(picks))
        filtered = CausalBandpass(sample_rate, len(MODEL_CHANNELS)).process(
            unfiltered
        )
        annotations = sorted(
            zip(raw.annotations.onset, raw.annotations.description),
            key=lambda item: item[0],
        )
        cues = [float(onset) for onset, code in annotations if code == "2"]
        rows: list[np.ndarray] = []
        labels: list[int] = []
        for index, cue in enumerate(cues):
            next_cue = cues[index + 1] if index + 1 < len(cues) else math.inf
            outcomes = [
                code
                for onset, code in annotations
                if cue < onset < next_cue and code in {"4", "8"}
            ]
            if len(outcomes) != 1 or cue < 4.0:
                continue
            stop = round(cue * sample_rate)
            start = stop - round(WINDOW_SECONDS * sample_rate)
            if start < 0 or stop > filtered.shape[1]:
                continue
            window = filtered[:, start:stop]
            if not window_is_clean(window):
                continue
            rows.append(extract_model_vector(window, sample_rate))
            labels.append(int(outcomes[0] == "8"))
        if not rows:
            raise RuntimeError(f"No usable Flip Cup trials in {path}")
        return np.vstack(rows), np.asarray(labels, dtype=int)
    finally:
        raw.close()


def train_deployment_model(
    session_files: Mapping[int, str | Path],
) -> DeploymentModel:
    sessions = {
        number: load_training_session(path)
        for number, path in session_files.items()
    }
    if len(sessions) < 2:
        raise ValueError("At least two sessions are required for held-out evaluation")
    held_out_results: list[dict[str, Any]] = []
    for held_out, (test_x, test_y) in sessions.items():
        train_sets = [
            values for number, values in sessions.items() if number != held_out
        ]
        train_x = np.vstack([values[0] for values in train_sets])
        train_y = np.concatenate([values[1] for values in train_sets])
        model = build_pipeline().fit(train_x, train_y)
        probability = model.predict_proba(test_x)[:, 1]
        held_out_results.append(
            {
                "held_out_session": held_out,
                "n": int(len(test_y)),
                "failures": int(test_y.sum()),
                "auc": float(roc_auc_score(test_y, probability)),
                "accuracy_at_0_5": float(
                    accuracy_score(test_y, probability >= 0.5)
                ),
            }
        )
    all_x = np.vstack([values[0] for values in sessions.values()])
    all_y = np.concatenate([values[1] for values in sessions.values()])
    evaluation = {
        "strategy": "leave-one-session-out",
        "sessions": held_out_results,
        "mean_auc": float(
            np.mean([result["auc"] for result in held_out_results])
        ),
        "pooled_training_trials": int(len(all_y)),
        "pooled_training_failures": int(all_y.sum()),
    }
    return DeploymentModel(
        model_id=MODEL_ID,
        pipeline=build_pipeline().fit(all_x, all_y),
        channels=MODEL_CHANNELS,
        feature_names=MODEL_FEATURES,
        window_seconds=WINDOW_SECONDS,
        target_sample_rate_hz=TARGET_SAMPLE_RATE_HZ,
        filter_band_hz=FILTER_BAND_HZ,
        filter_order=FILTER_ORDER,
        artifact_threshold_volts=ARTIFACT_THRESHOLD_VOLTS,
        label="flip_cup_failure",
        evaluation=evaluation,
    )


def save_deployment_model(
    model: DeploymentModel,
    model_path: str | Path,
    manifest_path: str | Path,
) -> None:
    model_file = Path(model_path)
    manifest_file = Path(manifest_path)
    model_file.parent.mkdir(parents=True, exist_ok=True)
    manifest_file.parent.mkdir(parents=True, exist_ok=True)
    joblib.dump(model, model_file)
    manifest_file.write_text(
        json.dumps(model.manifest(), indent=2),
        encoding="utf-8",
    )


def load_deployment_model(path: str | Path) -> DeploymentModel:
    model = joblib.load(path)
    if not isinstance(model, DeploymentModel):
        raise ValueError("Model artifact has an unexpected type")
    if (
        not model.model_id
        or model.channels != MODEL_CHANNELS
        or model.feature_names != MODEL_FEATURES
        or model.window_seconds != WINDOW_SECONDS
        or model.target_sample_rate_hz != TARGET_SAMPLE_RATE_HZ
    ):
        raise ValueError("Model artifact does not match the live feature contract")
    return model
