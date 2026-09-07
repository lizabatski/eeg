"""
core feature extraction
"""

from __future__ import annotations

import numpy as np
from scipy import signal, stats



#: Frequency bands in Hz
BANDS: dict[str, tuple[float, float]] = {
    "theta": (4.0, 8.0),
    "alpha": (8.0, 13.0),
    "alpha_low": (8.0, 10.5),
    "alpha_high": (10.5, 13.0),
    "beta": (13.0, 30.0),
}

# Total-power denominator for relative power
TOTAL_BAND: tuple[float, float] = (1.0, 40.0)

# Frontal midline sensors 
FRONTAL_MIDLINE = ("Fz", "FCz", "FC1", "FC2")

# Occipito-parietal sensors 
POSTERIOR = ("O1", "Oz", "O2", "POz", "PO3", "PO4", "PO7", "PO8", "P3", "Pz", "P4")

# rejection thresholds in volts
EEG_REJECT_PTP = 150e-6

# reject big blinks (filtered EOG: median 162, 99th 389, max 487 uV)
EOG_REJECT_PTP = 450e-6

# 4 standard deviations above the median is  threshold for outlier
DEFAULT_K = 4.0


ADAPTIVE_BOUNDS: dict[str, tuple[float, float]] = {
    "eeg": (60e-6, 250e-6),
    "eog": (250e-6, 800e-6),
}


# ---------------------------------------------------------------------------
# Spectral primitives
# ---------------------------------------------------------------------------

def compute_psd(
    window: np.ndarray,
    sfreq: float,
    nperseg_seconds: float = 1.0,
) -> tuple[np.ndarray, np.ndarray]:
    if window.ndim != 2:
        raise ValueError(f"expected (n_channels, n_samples), got shape {window.shape}")


    # window size
    nperseg = int(round(nperseg_seconds * sfreq))
    # use what you have
    nperseg = min(nperseg, window.shape[1])

    # compute the PSD using Welch's method  
    freqs, psd = signal.welch(
        window,
        fs=sfreq,
        nperseg=nperseg,
        noverlap=nperseg // 2,
        axis=-1,
    )
    return freqs, psd


def band_power(
    freqs: np.ndarray,
    psd: np.ndarray,
    band: tuple[float, float],
) -> np.ndarray:
    low, high = band
    mask = (freqs >= low) & (freqs < high)
    if not mask.any():
        raise ValueError(f"no PSD bins fall in band {band}; check sfreq/window length")

    # 10 channels x 50 frequencies - so average over frequencies 
    if mask.sum() < 2:
        return psd[:, mask].mean(axis=-1) * (high - low)

    # if you have more than 2 bins integrate it with trapezoid rule 
    # x - values and y -values 
    return np.trapezoid(psd[:, mask], freqs[mask], axis=-1)



# if else to check whether or not to keep a window
def window_is_clean(
    window: np.ndarray,
    ch_names: list[str],
    eeg_reject_ptp: float = EEG_REJECT_PTP,
    eog_reject_ptp: float = EOG_REJECT_PTP,
) -> bool:
    relevant = set(FRONTAL_MIDLINE) | set(POSTERIOR)
    ptp = np.ptp(window, axis=-1)

    for name, value in zip(ch_names, ptp):
        upper = name.upper()
        if upper.startswith("EOG"):
            if value > eog_reject_ptp:
                return False
        elif upper in {r.upper() for r in relevant}:
            if value > eeg_reject_ptp:
                return False
    return True


# eog versus eeg channel type
def channel_kind(name: str) -> str:
    return "eog" if name.upper().startswith("EOG") else "eeg"


class EOGRegressor:

    def __init__(self) -> None:
        self.coefficients_: dict[str, float] = {}

    @property
    def is_fitted(self) -> bool:
        return bool(self.coefficients_)

     # goal is to model ocular contamination as approximately EEG(t) = true EEG(t) + betaEOG(t)
    def fit(self, windows, ch_names: list[str]) -> "EOGRegressor":
        stack = np.asarray(windows, dtype=float)
        if stack.ndim != 3:
            raise ValueError(f"expected 3-D (n_windows, n_ch, n_samples), got {stack.shape}")

        eog_idx = [i for i, n in enumerate(ch_names) if channel_kind(n) == "eog"]
        if not eog_idx:
            raise ValueError("no EOG channel found; cannot fit ocular correction")

        flat = stack.transpose(1, 0, 2).reshape(len(ch_names), -1)
        eog = flat[eog_idx[0]] - flat[eog_idx[0]].mean()
        variance = float(eog @ eog)
        if variance <= 0:
            raise ValueError("EOG channel is flat; check the electrode")

        self.coefficients_ = {
            name: float((flat[i] - flat[i].mean()) @ eog) / variance
            for i, name in enumerate(ch_names)
            if channel_kind(name) != "eog"
        }
        return self

    def apply(self, window: np.ndarray, ch_names: list[str]) -> np.ndarray:
        """Return an ocular-corrected copy. EOG itself is left intact."""
        if not self.is_fitted:
            raise RuntimeError("EOGRegressor.fit must be called before apply")

        eog_idx = [i for i, n in enumerate(ch_names) if channel_kind(n) == "eog"]
        if not eog_idx:
            return window

        corrected = np.array(window, dtype=float, copy=True)
        eog = corrected[eog_idx[0]] - corrected[eog_idx[0]].mean()
        for i, name in enumerate(ch_names):
            b = self.coefficients_.get(name)
            if b is not None:
                corrected[i] -= b * eog
        return corrected

    def report(self, ch_names: list[str] | None = None) -> str:
        """Coefficients, largest first. Should fall off with distance from the eyes."""
        if not self.is_fitted:
            return "EOGRegressor: not fitted"
        items = (
            [(n, self.coefficients_[n]) for n in ch_names if n in self.coefficients_]
            if ch_names is not None
            else sorted(self.coefficients_.items(), key=lambda kv: -abs(kv[1]))
        )
        return "\n".join(
            ["EOG propagation coefficients:"]
            + [f"  {n:>6}  {v:+.3f}" for n, v in items]
        )


def count_blinks(
    eog: np.ndarray,
    sfreq: float,
    threshold: float,
    min_separation_s: float = 0.2,
) -> int:
    """Count blink-like excursions. Averaged over windows by the tracker, this is
    blink rate -- a drowsiness marker. Separate from extract_features because it
    needs a calibrated threshold, i.e. session state."""
    deviation = np.abs(eog - np.median(eog))
    above = deviation > threshold
    if not above.any():
        return 0

    onsets = np.flatnonzero(np.diff(above.astype(int)) == 1)
    if above[0]:
        onsets = np.r_[0, onsets]
    if len(onsets) == 0:
        return 0

    min_gap = int(round(min_separation_s * sfreq))
    kept = [onsets[0]]
    for onset in onsets[1:]:
        if onset - kept[-1] >= min_gap:
            kept.append(onset)
    return len(kept)


class AdaptiveRejector:

    def __init__(
        self,
        k: float = DEFAULT_K,
        bounds: dict[str, tuple[float, float]] | None = None,
    ) -> None:
        self.k = k
        self.bounds = bounds if bounds is not None else ADAPTIVE_BOUNDS
        self.thresholds_: dict[str, float] = {}
        self.clamped_: dict[str, str] = {}

    @property
    def is_fitted(self) -> bool:
        return bool(self.thresholds_)

    def fit(self, windows, ch_names: list[str]) -> "AdaptiveRejector":
        stack = np.asarray(windows, dtype=float)
        if stack.ndim != 3:
            raise ValueError(
                f"expected (n_windows, n_channels, n_samples), got {stack.shape}"
            )
        if len(stack) < 10:
            raise ValueError(
                f"need at least 10 calibration windows, got {len(stack)}"
            )
        if stack.shape[1] != len(ch_names):
            raise ValueError(
                f"{stack.shape[1]} channels in data but {len(ch_names)} names given"
            )

        ptp = np.ptp(stack, axis=-1)  # (n_windows, n_channels)

        self.thresholds_ = {}
        self.clamped_ = {}
        for i, name in enumerate(ch_names):
            values = ptp[:, i]
            centre = float(np.median(values))
            spread = float(stats.median_abs_deviation(values, scale="normal"))
            raw = centre + self.k * spread

            floor, ceiling = self.bounds[channel_kind(name)]
            if raw < floor:
                self.thresholds_[name] = floor
                self.clamped_[name] = "floor"
            elif raw > ceiling:
                self.thresholds_[name] = ceiling
                self.clamped_[name] = "ceiling"
            else:
                self.thresholds_[name] = raw

        return self

    def is_clean(self, window: np.ndarray, ch_names: list[str]) -> bool:
        if not self.is_fitted:
            raise RuntimeError("AdaptiveRejector.fit must be called before is_clean")

        relevant = {r.upper() for r in FRONTAL_MIDLINE} | {r.upper() for r in POSTERIOR}
        ptp = np.ptp(window, axis=-1)

        for name, value in zip(ch_names, ptp):
            upper = name.upper()
            if not (upper.startswith("EOG") or upper in relevant):
                continue
            limit = self.thresholds_.get(name)
            if limit is not None and value > limit:
                return False
        return True

    def report(self, ch_names: list[str] | None = None) -> str:
        if not self.is_fitted:
            return "AdaptiveRejector: not fitted"

        names = ch_names if ch_names is not None else sorted(self.thresholds_)
        lines = [f"adaptive thresholds (k={self.k}, microvolts):"]
        for name in names:
            if name not in self.thresholds_:
                continue
            note = self.clamped_.get(name, "")
            flag = f"  <- clamped to {note}" if note else ""
            lines.append(f"  {name:>6}  {self.thresholds_[name] * 1e6:7.1f}{flag}")
        return "\n".join(lines)



def _pick(ch_names: list[str], wanted: tuple[str, ...]) -> list[int]:
    lookup = {name.upper(): i for i, name in enumerate(ch_names)}
    return [lookup[w.upper()] for w in wanted if w.upper() in lookup]


def extract_features(
    window: np.ndarray,
    sfreq: float,
    ch_names: list[str],
) -> dict[str, float]:
    frontal = _pick(ch_names, FRONTAL_MIDLINE)
    posterior = _pick(ch_names, POSTERIOR)
    if not frontal and not posterior:
        raise ValueError(
            "none of the frontal-midline or posterior channels were found; "
            f"got channels {ch_names[:8]}..."
        )

    freqs, psd = compute_psd(window, sfreq)
    total = band_power(freqs, psd, TOTAL_BAND)
    # Guard against a flat/dead channel producing a divide-by-zero.
    total = np.maximum(total, np.finfo(float).tiny)

    def relative(band: tuple[float, float], picks: list[int]) -> float:
        """Mean log10 relative power in ``band`` across ``picks``."""
        if not picks:
            return np.nan
        rel = band_power(freqs, psd, band)[picks] / total[picks]
        # Final guard: a genuinely silent band would still give log10(0).
        rel = np.maximum(rel, np.finfo(float).tiny)
        return float(np.mean(np.log10(rel)))

    feats: dict[str, float] = {}
    for band_name, band in BANDS.items():
        feats[f"{band_name}_frontal"] = relative(band, frontal)
        feats[f"{band_name}_posterior"] = relative(band, posterior)

    # The headline contrast: disengagement (posterior alpha) against control
    # (frontal theta). In log space a ratio is a difference, so this is just
    # the signed distance between the two markers.
    feats["ratio_alpha_theta"] = feats["alpha_posterior"] - feats["theta_frontal"]

    # Ocular activity as a declared feature rather than a contaminant. Averaged
    # over windows by the tracker this approximates blink rate, a drowsiness
    # marker. Omitted when no EOG channel exists.
    eog = [i for i, n in enumerate(ch_names) if channel_kind(n) == "eog"]
    if eog:
        ptp = float(np.ptp(window[eog[0]]))
        feats["eog_ptp"] = float(np.log10(max(ptp, np.finfo(float).tiny)))

    return feats


#: Canonical feature order. Both the trainer and the live loop build their
#: vectors through this list so a column can never silently transpose between
#: the two paths.
FEATURE_NAMES: list[str] = (
    [f"{b}_{site}" for b in BANDS for site in ("frontal", "posterior")]
    + ["ratio_alpha_theta", "eog_ptp"]
)


def features_to_vector(
    feats: dict[str, float],
    names: list[str] | None = None,
) -> np.ndarray:
    if names is None:
        names = [n for n in FEATURE_NAMES if n in feats]
    return np.array([feats[name] for name in names], dtype=float)
