"""
Open an ANT Neuro .cnt file and scroll through it.

SETUP (once):
    pip install mne antio matplotlib PyQt6

RUN:
    python view_eeg.py path/to/file.cnt

CONTROLS in the window:
    left / right arrows   scroll through time
    up / down arrows      scroll through channels
    + / -                 zoom the traces bigger or smaller
    a                     show/hide the event markers
"""

import sys
import mne


def main(path):
    raw = mne.io.read_raw_ant(path, preload=True)

    print(f"\n  file       {path}")
    print(f"  duration   {raw.n_times / raw.info['sfreq']:.1f} seconds")
    print(f"  channels   {raw.info['nchan']} at {raw.info['sfreq']:.0f} Hz")
    print(f"  markers    {len(raw.annotations)}\n")

 
    raw.filter(1, 40)

    raw.plot(
        duration=10,        # seconds visible at once
        n_channels=20,      # channels visible at once
        scalings=dict(eeg=50e-6),   # 50 microvolts per channel row
        block=True,
    )


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print(__doc__)
        sys.exit(1)
    main(sys.argv[1])