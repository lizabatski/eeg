"""Export a slide-ready plot from the terminal demo's JSONL snapshots."""
import json
from pathlib import Path

import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

ROOT = Path(__file__).resolve().parents[1]
rows = [json.loads(line) for line in (ROOT / 'demo_states.jsonl').read_text(encoding='utf-8').splitlines() if line.strip()]
times = [r['recording_time_s'] for r in rows]
scores = [float('nan') if r['state_score_z'] is None else r['state_score_z'] for r in rows]
fig, ax = plt.subplots(figsize=(12, 5.5), layout='constrained')
ax.plot(times, scores, color='#2563eb', linewidth=2, label='EEG change from baseline')
ax.axhline(1.5, color='#d97706', linestyle='--', label='Experimental cue threshold (+1.5)')
ax.axhline(0, color='#94a3b8', linewidth=0.8)
ready = next((r['recording_time_s'] for r in rows if r['status'] == 'ok'), times[-1])
ax.axvspan(0, ready, color='#94a3b8', alpha=0.18, label='Warm-up / baseline collection')
cues = [r for r in rows if r['intervene']]
ax.scatter([r['recording_time_s'] for r in cues], [r['state_score_z'] for r in cues],
           color='#dc2626', marker='v', s=90, zorder=3, label='Reset cue emitted')
ax.set(xlabel='Recording time (seconds)', ylabel='Alpha/theta contrast (baseline z-score)',
       title='Recorded Flip Cup EEG drives an experimental feedback rule', xlim=(0, times[-1]))
ax.spines[['top', 'right']].set_visible(False)
ax.legend(loc='lower left', fontsize=9)
fig.supxlabel('Recorded-data replay, not live acquisition or validated failure prediction. Cues have a 10-second cooldown.', fontsize=10)
out = ROOT / 'artifacts'
out.mkdir(exist_ok=True)
for extension in ('png', 'svg'):
    fig.savefig(out / f'eeg_replay.{extension}', dpi=200)
print(out / 'eeg_replay.png')
