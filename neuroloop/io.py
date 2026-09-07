"""
loading and preprocessing ANT Neuro ``.cnt`` recordings.
"""

from __future__ import annotations

from pathlib import Path

import mne
import numpy as np

DEAD_CHANNELS = ("M1", "M2")

#: Band-pass applied to every recording. The high-pass removes electrode drift
#: and sweat artefact; the low-pass sits below the 60 Hz line frequency used in
#: North America. Must be kept identical in the live loop.
FILTER_BAND = (1.0, 40.0)


def load_cnt(path: str | Path, verbose: bool = False) -> mne.io.BaseRaw:
    """Read an ANT ``.cnt`` file and apply the standard preprocessing.

    Steps, in order:

    1. Read with ``mne.io.read_raw_ant`` (backed by the ``antio`` reader).
    2. Mark ``EOG`` as an EOG channel so MNE stops treating it as cortex.
    3. Drop the disconnected mastoids.
    4. Band-pass filter to :data:`FILTER_BAND`.

    Parameters
    ----------
    path
        Path to the ``.cnt`` file.
    verbose
        Passed through to MNE. Default ``False`` because the reader is chatty.

    Returns
    -------
    A preloaded :class:`mne.io.Raw`.
    """
    raw = mne.io.read_raw_ant(str(path), preload=True, verbose=verbose)

    if "EOG" in raw.ch_names:
        raw.set_channel_types({"EOG": "eog"}, verbose=verbose)

    drop = [ch for ch in DEAD_CHANNELS if ch in raw.ch_names]
    if drop:
        raw.drop_channels(drop)

    # picks must be explicit: raw.filter() defaults to EEG only, so once EOG is
    # typed as 'eog' it would be left unfiltered and drift-dominated -- which
    # silently breaks EOG regression and every EOG amplitude threshold.
    picks = ["eeg"]
    if any(ch == "eog" for ch in raw.get_channel_types()):
        picks.append("eog")
    raw.filter(*FILTER_BAND, picks=picks, verbose=verbose)
    return raw


def marker_onsets(raw: mne.io.BaseRaw, code: str) -> np.ndarray:
    """Onset times in seconds of every annotation whose description is ``code``.

    ANT stores trigger codes as the annotation description, as a string of the
    integer value -- ``"4"`` for a made shot, and so on.
    """
    return np.array(
        [o for o, d in zip(raw.annotations.onset, raw.annotations.description) if d == code]
    )


def window_around(
    raw: mne.io.BaseRaw,
    stop_time: float,
    length: float,
    picks: list[str] | None = None,
) -> np.ndarray | None:
    """Extract the ``length``-second window that *ends* at ``stop_time``.

    Ending rather than starting at the marker is the whole design: we want the
    brain state immediately before the stimulus, using only data that would
    genuinely have been available to a live system at that moment. Nothing
    after ``stop_time`` may enter the window, or the model is peeking into the
    future and the offline accuracy becomes a fiction.

    Parameters
    ----------
    raw
        Preprocessed recording.
    stop_time
        Time in seconds at which the window ends -- typically a cue marker.
    length
        Window length in seconds.
    picks
        Channel names to keep. ``None`` keeps everything.

    Returns
    -------
    ``(n_channels, n_samples)`` array in volts, or ``None`` if the requested
    window would run off the start or end of the recording.
    """
    sfreq = raw.info["sfreq"]
    start_sample = int(round((stop_time - length) * sfreq))
    stop_sample = int(round(stop_time * sfreq))

    if start_sample < 0 or stop_sample > raw.n_times:
        return None

    pick_idx = mne.pick_channels(raw.ch_names, picks) if picks else None
    data = raw.get_data(picks=pick_idx, start=start_sample, stop=stop_sample)
    return data


def channel_names(raw: mne.io.BaseRaw, picks: list[str] | None = None) -> list[str]:
    """Channel names in the same order :func:`window_around` returns rows."""
    if picks is None:
        return list(raw.ch_names)
    idx = mne.pick_channels(raw.ch_names, picks)
    return [raw.ch_names[i] for i in idx]
