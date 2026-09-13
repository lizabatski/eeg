"""
Per-person calibration.

Team: Monster's Inc

:class:`BaselineNormaliser` z-scores a feature vector against a per-person
baseline: fit ``mean``/``std`` over a calibration block of windows, then
``transform`` subtracts the mean and divides by the std for every later
window. This expresses each feature as "how far from this person's own
resting state," which controls for large between-person differences in
absolute band power (skull thickness, electrode contact, individual EEG
amplitude) that would otherwise dominate a pooled-population comparison. A
std of exactly zero (a dead-flat feature) is floored to machine epsilon so a
degenerate channel produces a large finite z-score instead of a division by
zero.
"""

from __future__ import annotations

import numpy as np


class BaselineNormaliser:

    def __init__(self, min_windows: int = 30) -> None:
        self.min_windows = min_windows
        self.mean_: np.ndarray | None = None
        self.std_: np.ndarray | None = None

    @property
    def is_fitted(self) -> bool:
        return self.mean_ is not None

    def fit(self, vectors: np.ndarray) -> "BaselineNormaliser":
        vectors = np.asarray(vectors, dtype=float)
        if vectors.ndim != 2:
            raise ValueError(f"expected 2-D array, got shape {vectors.shape}")
        if len(vectors) < self.min_windows:
            raise ValueError(
                f"calibration needs at least {self.min_windows} windows, "
                f"got {len(vectors)} -- collect a longer baseline block"
            )

        self.mean_ = vectors.mean(axis=0)
        # A dead-flat feature would give std 0 and produce infinities downstream.
        self.std_ = np.maximum(vectors.std(axis=0, ddof=1), np.finfo(float).eps)
        return self

    def transform(self, vector: np.ndarray) -> np.ndarray:
        """Z-score one feature vector, or a batch of them, against the baseline."""
        if not self.is_fitted:
            raise RuntimeError("BaselineNormaliser.fit must be called before transform")
        return (np.asarray(vector, dtype=float) - self.mean_) / self.std_
