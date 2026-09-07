"""Replay ANT Flip Cup EEG through a causal processor; emit frontend snapshots."""
from __future__ import annotations

import argparse
import contextlib
import json
from pathlib import Path
import sys
import time

import mne
import numpy as np
from scipy.signal import butter, sosfilt, sosfilt_zi

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from neuroloop.features import (FRONTAL_MIDLINE, POSTERIOR, extract_features,
                                window_is_clean)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--file', type=Path, default=Path(__file__).resolve().parents[1] /
                        'EEG_flipcup/Ewing_Patrick_2026-08-10_13-07-25_session-01.cnt')
    parser.add_argument('--seconds', type=float, default=90, help='Recording seconds to replay')
    parser.add_argument('--speed', type=float, default=1, help='Playback multiplier; 0 = fastest')
    parser.add_argument('--json', action='store_true', help='One JSON snapshot per line')
    args = parser.parse_args()
    if args.seconds <= 0 or args.speed < 0:
        parser.error('seconds must be positive and speed must be nonnegative')
    # Keep library messages off the machine-readable stdout channel.
    with contextlib.redirect_stdout(sys.stderr):
        raw = mne.io.read_raw_ant(str(args.file), preload=False, verbose=False)
    wanted = set(FRONTAL_MIDLINE + POSTERIOR + ('EOG',))
    picks = [i for i, name in enumerate(raw.ch_names) if name.upper() in
             {n.upper() for n in wanted}]
    names = [raw.ch_names[i] for i in picks]
    if not any(n in names for n in FRONTAL_MIDLINE) or not any(n in names for n in POSTERIOR):
        parser.error('Recording needs frontal and posterior feature channels')
    fs = float(raw.info['sfreq'])
    step = max(1, round(fs * 0.5))
    window_size = round(fs * 4)
    sos = butter(4, [1, 40], fs=fs, btype='bandpass', output='sos')
    zi = None
    buffer = np.empty((len(picks), 0))
    baseline = []
    last_cue = -float('inf')
    started = time.monotonic()
    print('REPLAY of recorded ANT EEG | experimental alpha/theta rule, not a failure predictor', file=sys.stderr)
    print('4 s window | 0.5 s updates | 30 clean baseline windows | 10 s cue cooldown', file=sys.stderr)
    try:
        for start in range(0, min(raw.n_times, round(args.seconds * fs)), step):
            stop = min(start + step, raw.n_times, round(args.seconds * fs))
            with contextlib.redirect_stdout(sys.stderr):
                chunk = raw.get_data(picks=picks, start=start, stop=stop)
            if zi is None:
                zi = sosfilt_zi(sos)[:, None, :] * chunk[None, :, :1]
            filtered, zi = sosfilt(sos, chunk, axis=-1, zi=zi)
            buffer = np.concatenate((buffer, filtered), axis=1)[:, -window_size:]
            elapsed = stop / fs
            snapshot = dict(schema_version=1, source='replay', recording_time_s=round(elapsed, 3),
                            status='warming_up', baseline_windows=len(baseline),
                            alpha_posterior=None, theta_frontal=None, state_score_z=None,
                            intervene=False, cue_id=None, message='Collecting four seconds of EEG')
            if buffer.shape[1] == window_size:
                if not np.isfinite(buffer).all() or not window_is_clean(buffer, names):
                    snapshot.update(status='artifact', message='Signal noisy; feedback paused')
                else:
                    features = extract_features(buffer, fs, names)
                    ratio = features['ratio_alpha_theta']
                    snapshot.update(alpha_posterior=features['alpha_posterior'],
                                    theta_frontal=features['theta_frontal'])
                    if len(baseline) < 30:
                        baseline.append(ratio)
                        snapshot.update(status='calibrating', baseline_windows=len(baseline),
                                        message=f'Baseline {len(baseline)}/30 clean windows')
                    else:
                        scale = float(np.std(baseline, ddof=1))
                        if scale < 1e-6:
                            snapshot.update(status='invalid_baseline', message='Baseline has too little variation; restart')
                        else:
                            score = float((ratio - np.mean(baseline)) / scale)
                            cue = score > 1.5 and elapsed - last_cue >= 10
                            if cue:
                                last_cue = elapsed
                            snapshot.update(status='ok', state_score_z=score, intervene=cue,
                                            cue_id=f'replay-{stop}' if cue else None,
                                            message='Pause and reset' if cue else 'Monitoring EEG')
            if args.speed:
                time.sleep(max(0, started + elapsed / args.speed - time.monotonic()))
            if args.json:
                print(json.dumps(snapshot, allow_nan=False), flush=True)
            else:
                score = snapshot['state_score_z']
                value = ' -- ' if score is None else f'{score:+.2f}'
                print(f'{elapsed:6.1f}s | {snapshot["status"]:16} | score {value} | {snapshot["message"]}', flush=True)
    except KeyboardInterrupt:
        print('Replay stopped.', file=sys.stderr)
    finally:
        raw.close()


if __name__ == '__main__':
    main()
