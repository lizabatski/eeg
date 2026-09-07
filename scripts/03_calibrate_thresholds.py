"""
Step 3 -- fit artefact thresholds from a calibration block instead of guessing.

Team <NUMBER>: <MEMBER NAMES>
NOVA Buildathon 2026 / ANT Neuro challenge.

WHY
---
The original rejection thresholds (150 uV EEG, 500 uV EOG) were conventional
values, not measured ones. Checked against the ANT reference recording, 150 uV
sits above the 99th percentile of window peak-to-peak, so it removed only
0.5% of windows -- it was a catastrophe filter, not artefact control.

That is survivable on a clean recording from one person. It does not port.
COG-BCI was recorded on a different amplifier (ActiCHamp, 500 Hz) and build
day is unknown. A threshold that does not match the noise floor either lets
artefacts through or starves the loop.

:class:`neuroloop.features.AdaptiveRejector` fits ``median + k * MAD`` per
channel from the calibration block the user already has to sit through.

WHAT THIS SCRIPT SHOWS
----------------------
Fitting on the first two minutes of each flip-cup session and screening the
remainder demonstrates three things:

* thresholds differ substantially *between channels* -- justifying per-channel
  rather than pooled fitting;
* they differ substantially *between sessions for the same person on the same
  day* -- which is the case a fixed constant cannot handle;
* the clamps fire, and the report says where, so a bad electrode is visible
  immediately rather than after a wasted session.

RUN
    python scripts/03_calibrate_thresholds.py
"""

from __future__ import annotations

import sys
from pathlib import Path

import numpy as np

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from neuroloop import features, io  # noqa: E402

EEG_DIR = Path("EEG_flipcup")
SESSIONS = {
    1: "Ewing_Patrick_2026-08-10_13-07-25_session-01.cnt",
    2: "Ewing_Patrick_2026-08-10_13-07-25_session-02.cnt",
}

#: Analysis window length. Peak-to-peak scales with window duration, so the
#: calibration windows must be the same length as the run-time ones.
WINDOW = 1.5

#: Calibration block length in seconds. Two minutes at a 1.5 s window gives
#: 80 windows -- comfortably above the 10-window minimum, and short enough
#: that a user will actually sit through it.
CALIBRATION_SECONDS = 120.0

REPORT_CHANNELS = ["Fz", "FCz", "FC1", "FC2", "Pz", "POz", "Oz", "O1", "O2", "EOG"]


def collect_windows(raw, start: float, stop: float) -> np.ndarray:
    """Non-overlapping windows of :data:`WINDOW` seconds between two times."""
    out = []
    t = start + WINDOW
    while t <= stop:
        window = io.window_around(raw, stop_time=t, length=WINDOW)
        if window is not None:
            out.append(window)
        t += WINDOW
    return np.array(out)


def main() -> int:
    if not EEG_DIR.exists():
        print(f"ERROR: cannot find {EEG_DIR}", file=sys.stderr)
        return 1

    fitted = {}

    for number, filename in SESSIONS.items():
        raw = io.load_cnt(EEG_DIR / filename)
        ch_names = io.channel_names(raw)
        duration = raw.n_times / raw.info["sfreq"]

        calibration = collect_windows(raw, 0.0, CALIBRATION_SECONDS)
        held_out = collect_windows(raw, CALIBRATION_SECONDS, duration)

        rejector = features.AdaptiveRejector().fit(calibration, ch_names)
        fitted[number] = rejector

        print(f"=== session {number} "
              f"({len(calibration)} calibration windows, "
              f"{len(held_out)} held out) ===")
        print(rejector.report(REPORT_CHANNELS))

        fixed_rejects = sum(
            1 for w in held_out if not features.window_is_clean(w, ch_names)
        )
        adaptive_rejects = sum(
            1 for w in held_out if not rejector.is_clean(w, ch_names)
        )
        print(f"  rejection on held-out data: "
              f"fixed {fixed_rejects / len(held_out):.1%}, "
              f"adaptive {adaptive_rejects / len(held_out):.1%}")
        print()

    # The argument for adaptivity, stated numerically.
    print("=== same channel, same person, same day: fitted threshold by session ===")
    print(f"{'channel':>8}{'session 1':>12}{'session 2':>12}{'ratio':>9}")
    for name in REPORT_CHANNELS:
        one = fitted[1].thresholds_.get(name)
        two = fitted[2].thresholds_.get(name)
        if one is None or two is None:
            continue
        ratio = max(one, two) / min(one, two)
        print(f"{name:>8}{one * 1e6:>11.1f}{two * 1e6:>12.1f}{ratio:>9.2f}x")

    print("\nA single hard-coded constant has to be correct for every cell above.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
