"""Descriptive rest-versus-task alpha check with causal preprocessing."""
import csv
import json
from pathlib import Path
import sys

import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import mne
import numpy as np
from scipy.signal import butter, sosfilt, sosfilt_zi

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from neuroloop.features import extract_features, window_is_clean

ROOT = Path(__file__).resolve().parents[1]


def main():
    raw = mne.io.read_raw_ant(str(ROOT / 'Eyes open eyes closed' /
        'Ewing_Patrick_2026-08-10_13-07-25_EO-EC.cnt'), preload=True, verbose=False)
    raw.drop_channels([n for n in ('M1', 'M2') if n in raw.ch_names])
    fs = raw.info['sfreq']
    data = raw.get_data()
    sos = butter(4, [1, 40], fs=fs, btype='bandpass', output='sos')
    data, _ = sosfilt(sos, data, axis=-1, zi=sosfilt_zi(sos)[:, None, :] * data[None, :, :1])
    events = sorted((float(t), str(d)) for t, d in zip(raw.annotations.onset, raw.annotations.description))
    rows, blocks = [], []
    for condition, begin, end in [('Rest', '13', '14'), ('Task', '11', '12')]:
        opened = None
        for t, code in events:
            if code == begin:
                if opened is not None:
                    raise ValueError(f'Unmatched {condition} start marker')
                opened = t
            elif code == end:
                if opened is None:
                    raise ValueError(f'Unmatched {condition} stop marker')
                block_id = len(blocks) + 1
                values, rejected = [], 0
                # Discard the first four seconds after each transition to reduce carryover.
                for start in np.arange(opened + 4, t - 2 + 1e-8, 2):
                    win = data[:, round(start * fs):round((start + 2) * fs)]
                    if not np.isfinite(win).all() or not window_is_clean(win, raw.ch_names):
                        rejected += 1
                        continue
                    alpha = extract_features(win, fs, raw.ch_names)['alpha_posterior']
                    values.append(alpha)
                    rows.append(dict(condition=condition, block=block_id, time_s=float(start + 2), alpha_log_relative=alpha))
                if not values:
                    raise ValueError(f'No valid windows in block {block_id}')
                blocks.append(dict(condition=condition, block=block_id, start_s=opened, stop_s=t,
                                   accepted=len(values), rejected=rejected, mean_alpha=float(np.mean(values))))
                opened = None
        if opened is not None:
            raise ValueError(f'Unclosed {condition} block')
    means = {c: float(np.mean([b['mean_alpha'] for b in blocks if b['condition'] == c])) for c in ('Rest', 'Task')}
    fold = 10 ** (means['Rest'] - means['Task'])
    report = dict(blocks=blocks, block_weighted_means=means, rest_task_geometric_power_ratio=fold,
                  interpretation='Descriptive posterior-alpha contrast, not a prediction accuracy or proof of pipeline correctness.',
                  caveat='Marker-defined rest versus active task. Eye-state interpretation is not independently verified here; conditions also differ in task engagement. Windows are not independent subjects.')
    out = ROOT / 'artifacts'
    out.mkdir(exist_ok=True)
    (out / 'causal_alpha_results.json').write_text(json.dumps(report, indent=2), encoding='utf-8')
    with (out / 'causal_alpha_windows.csv').open('w', newline='', encoding='utf-8') as f:
        writer = csv.DictWriter(f, fieldnames=rows[0].keys())
        writer.writeheader()
        writer.writerows(rows)
    fig, ax = plt.subplots(figsize=(9, 5.5), layout='constrained')
    for x, condition, color in [(0, 'Rest', '#2563eb'), (1, 'Task', '#d97706')]:
        vals = [b['mean_alpha'] for b in blocks if b['condition'] == condition]
        offsets = np.linspace(-.09, .09, len(vals))
        ax.scatter(x + offsets, vals, color=color, s=65, label=f'{condition}: {len(vals)} block means')
        ax.hlines(means[condition], x - .2, x + .2, color=color, linewidth=3)
    ax.set(xticks=[0, 1], xticklabels=['Rest (markers 13–14)', 'Active task (markers 11–12)'],
           ylabel='Posterior alpha (log10 relative power)',
           title='Causal EEG processing recovers a rest–task alpha contrast', xlim=(-.5, 1.5))
    ax.spines[['top', 'right']].set_visible(False)
    ax.legend()
    fig.supxlabel(f'Rest/task geometric power ratio: {fold:.2f}× · Each dot is one block\nDescriptive sanity check; not pure eyes-open/closed isolation or predictive validation.', fontsize=10)
    for ext in ('png', 'svg'):
        fig.savefig(out / f'causal_alpha.{ext}', dpi=220)
    raw.close()
    print(json.dumps(report, indent=2))


if __name__ == '__main__':
    main()
