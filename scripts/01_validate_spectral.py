"""
Step 1 -- prove the spectral pipeline is correct before trusting it.

Team <NUMBER>: <MEMBER NAMES>
NOVA Buildathon 2026 / ANT Neuro challenge.

WHY THIS SCRIPT EXISTS
----------------------
Every downstream result depends on ``features.extract_features`` computing
band power correctly. A wrong filter, a transposed axis, or a units error
would still produce plausible-looking classifier accuracies -- and we would
not find out until a judge asked.

So we test it against the single most reliable effect in all of EEG:
**occipital alpha is much larger with the eyes closed than open.** It is a
factor-of-several effect, visible in one subject without averaging. If our
code cannot recover it, the code is broken.

The provided ``EO-EC`` recording is really an auditory oddball task
(8 = standard, 9 = deviant, 11/12 = task block start/end). Interleaved
between the task blocks are four 20-second rest periods, bracketed by markers
13 and 14.

Scanning posterior alpha across the whole 556 s recording shows all four rest
blocks sitting far *above* the surrounding task blocks -- so all four are
eyes-closed rest, and the eyes-open comparison is the task itself. The
contrast this script tests is therefore:

    eyes CLOSED = rest blocks       (marker 13 -> 14)
    eyes OPEN   = oddball task      (marker 11 -> 12)

Caveat, stated honestly because it matters: the eyes-open condition is an
active auditory task, not quiet eyes-open rest. Task engagement suppresses
alpha on its own, so this contrast slightly overstates what pure EO-vs-EC
would give. That is fine for its purpose -- we are testing that our code can
recover a large, known-direction alpha modulation, not measuring its exact
size.

RUN
    python scripts/01_validate_spectral.py
"""

from __future__ import annotations

import sys
from pathlib import Path

import numpy as np

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from neuroloop import features, io  # noqa: E402

EO_EC_FILE = (
    Path("Eyes open eyes closed") / "Ewing_Patrick_2026-08-10_13-07-25_EO-EC.cnt"
)

REST_START_CODE = "13"
REST_STOP_CODE = "14"
TASK_START_CODE = "11"
TASK_STOP_CODE = "12"

#: Length of the sub-windows each rest block is chopped into. Two seconds is
#: long enough for a stable alpha estimate and short enough to give us several
#: independent samples per 20 s block.
SUB_WINDOW = 2.0


def paired_blocks(raw, start_code: str, stop_code: str) -> list[tuple[float, float]]:
    """Pair each ``start_code`` marker with the next ``stop_code`` marker after it."""
    starts = io.marker_onsets(raw, start_code)
    stops = io.marker_onsets(raw, stop_code)

    blocks = []
    for start in starts:
        later = stops[stops > start]
        if len(later):
            blocks.append((float(start), float(later[0])))
    return blocks


def alpha_in_block(raw, start: float, stop: float) -> tuple[np.ndarray, int]:
    """Posterior alpha for every clean sub-window inside one rest block.

    Returns the per-window values and the number of windows dropped as
    artefact, so an over-aggressive rejection threshold cannot hide.
    """
    ch_names = io.channel_names(raw)
    values, dropped = [], 0

    # Step by a full window (no overlap) so the samples are independent.
    t = start + SUB_WINDOW
    while t <= stop:
        window = io.window_around(raw, stop_time=t, length=SUB_WINDOW)
        if window is not None:
            if features.window_is_clean(window, ch_names):
                feats = features.extract_features(
                    window, raw.info["sfreq"], ch_names
                )
                values.append(feats["alpha_posterior"])
            else:
                dropped += 1
        t += SUB_WINDOW

    return np.array(values), dropped


def collect(raw, blocks: list[tuple[float, float]]) -> tuple[np.ndarray, int]:
    """Posterior alpha for every clean sub-window across a list of blocks."""
    all_values, all_dropped = [], 0
    for start, stop in blocks:
        values, dropped = alpha_in_block(raw, start, stop)
        all_values.append(values)
        all_dropped += dropped
    return np.concatenate(all_values), all_dropped


def main() -> int:
    path = EO_EC_FILE
    if not path.exists():
        print(f"ERROR: cannot find {path}", file=sys.stderr)
        return 1

    print(f"loading {path.name} ...")
    raw = io.load_cnt(path)
    print(
        f"  {raw.info['nchan']} channels at {raw.info['sfreq']:.0f} Hz, "
        f"{raw.n_times / raw.info['sfreq']:.0f} s"
    )

    rest = paired_blocks(raw, REST_START_CODE, REST_STOP_CODE)
    task = paired_blocks(raw, TASK_START_CODE, TASK_STOP_CODE)
    print(f"  {len(rest)} rest blocks (eyes closed), "
          f"{len(task)} task blocks (eyes open)\n")

    closed_vals, closed_drop = collect(raw, rest)
    open_vals, open_drop = collect(raw, task)

    total_windows = len(closed_vals) + len(open_vals) + closed_drop + open_drop
    drop_rate = (closed_drop + open_drop) / max(total_windows, 1)

    print("posterior alpha, log10 relative power -- higher means more alpha")
    print(f"  eyes closed : {closed_vals.mean():>7.3f}  "
          f"sd {closed_vals.std():.3f}  (n={len(closed_vals)})")
    print(f"  eyes open   : {open_vals.mean():>7.3f}  "
          f"sd {open_vals.std():.3f}  (n={len(open_vals)})")
    print(f"  artefact rejection dropped {drop_rate:.1%} of windows")

    difference = closed_vals.mean() - open_vals.mean()
    pooled_sd = np.sqrt((closed_vals.var(ddof=1) + open_vals.var(ddof=1)) / 2)
    cohens_d = difference / pooled_sd
    fold = 10 ** difference  # log10 difference back to a multiplicative factor

    print(f"\n  difference  : {difference:>7.3f} log10 units")
    print(f"  fold change : {fold:>7.2f}x more posterior alpha with eyes closed")
    print(f"  Cohen's d   : {cohens_d:>7.2f}")

    if difference > 0 and fold > 2.0 and cohens_d > 0.8:
        print("\nPASS: the classic eyes-closed alpha effect is recovered cleanly,")
        print("in the right direction and at the expected magnitude.")
        print("The spectral pipeline is trustworthy. Proceed to step 2.")
        return 0

    print("\nFAIL: the expected alpha modulation was not recovered.")
    print("Check the filter band, channel selection, and units before")
    print("trusting any downstream classification result.")
    return 1


if __name__ == "__main__":
    raise SystemExit(main())
