"""Reproducible fixed-window, held-out-session evaluation and ROC export."""
from pathlib import Path
import json
import sys
import csv

import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import mne
import numpy as np
from scipy.signal import butter, sosfilt, sosfilt_zi
from sklearn.pipeline import make_pipeline
from sklearn.preprocessing import StandardScaler
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import roc_auc_score, roc_curve, accuracy_score

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from neuroloop.features import extract_features, features_to_vector, window_is_clean

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / 'artifacts'


def load_session(number):
    path = ROOT / 'EEG_flipcup' / f'Ewing_Patrick_2026-08-10_13-07-25_session-0{number}.cnt'
    raw = mne.io.read_raw_ant(str(path), preload=True, verbose=False)
    raw.drop_channels([n for n in ('M1', 'M2') if n in raw.ch_names])
    fs = raw.info['sfreq']
    data = raw.get_data()
    sos = butter(4, [1, 40], fs=fs, btype='bandpass', output='sos')
    zi = sosfilt_zi(sos)[:, None, :] * data[None, :, :1]
    data, _ = sosfilt(sos, data, axis=-1, zi=zi)
    annotations = [(float(t), str(d)) for t, d in zip(raw.annotations.onset, raw.annotations.description)]
    cues = [t for t, d in annotations if d == '2']
    rows, labels, times = [], [], []
    rejected = dict(ambiguous_or_missing_outcome=0, startup=0, artifact=0, nonfinite=0)
    for i, cue in enumerate(cues):
        end = cues[i + 1] if i + 1 < len(cues) else raw.n_times / fs
        outcomes = [d for t, d in annotations if cue < t < end and d in ('4', '8')]
        if len(outcomes) != 1:
            rejected['ambiguous_or_missing_outcome'] += 1
            continue
        if cue - 1.5 < 4:
            rejected['startup'] += 1
            continue
        window = data[:, round((cue - 1.5) * fs):round(cue * fs)]
        if not window_is_clean(window, raw.ch_names):
            rejected['artifact'] += 1
            continue
        vector = features_to_vector(extract_features(window, fs, raw.ch_names))
        if not np.isfinite(vector).all():
            rejected['nonfinite'] += 1
            continue
        rows.append(vector)
        labels.append(int(outcomes[0] == '8'))
        times.append(cue)
    raw.close()
    print(f'Session {number}: {len(rows)}/{len(cues)} trials retained; exclusions {rejected}', flush=True)
    return np.asarray(rows), np.asarray(labels), times, rejected


def predict(x, y, test):
    return make_pipeline(StandardScaler(), LogisticRegression(class_weight='balanced',
                         max_iter=2000, random_state=0)).fit(x, y).predict_proba(test)[:, 1]


def main():
    OUT.mkdir(exist_ok=True)
    sessions = [load_session(1), load_session(2)]
    results, predictions = [], []
    fig, ax = plt.subplots(figsize=(8, 6), layout='constrained')
    for held in range(2):
        x, y, times, rejected = sessions[held]
        train_x, train_y, _, _ = sessions[1 - held]
        p = predict(train_x, train_y, x)
        auc = float(roc_auc_score(y, p))
        result = dict(test_session=held + 1, train_session=2 - held, n=len(y),
                      failures=int(y.sum()), auc=auc, accuracy=float(accuracy_score(y, p > .5)),
                      training_majority_baseline_accuracy=float(np.mean(y == int(train_y.mean() >= .5))),
                      excluded=rejected)
        results.append(result)
        predictions.extend(dict(session=held + 1, cue_time_s=t, failure=int(label), failure_score=float(score))
                           for t, label, score in zip(times, y, p))
        fpr, tpr, _ = roc_curve(y, p)
        ax.step(fpr, tpr, where='post', label=f'Test session {held + 1}: AUROC {auc:.3f} (n={len(y)})')
        print(result, flush=True)
    observed = float(np.mean([r['auc'] for r in results]))
    rng = np.random.default_rng(0)
    null = []
    print('Running 1,000 within-session label permutations...', flush=True)
    for iteration in range(1000):
        ys = [rng.permutation(s[1]) for s in sessions]
        aucs = [roc_auc_score(ys[h], predict(sessions[1-h][0], ys[1-h], sessions[h][0])) for h in range(2)]
        null.append(float(np.mean(aucs)))
        if (iteration + 1) % 200 == 0:
            print(f'{iteration + 1}/1000 permutations', flush=True)
    pvalue = float((1 + np.sum(np.asarray(null) >= observed)) / 1001)
    report = dict(window_seconds=1.5, preprocessing='causal fourth-order Butterworth 1-40 Hz',
                  evaluation='leave-one-session-out; unweighted mean of two session AUROCs',
                  sessions=results, mean_session_auc=observed, permutation_p=pvalue,
                  permutation_count=1000, seed=0,
                  limitations=['One participant, two sessions; no population generalization.',
                               'Exploratory reanalysis of previously inspected data, not preregistered.',
                               'Label shuffles preserve session counts but assume within-session exchangeability; temporal dependence may invalidate that assumption.',
                               'Fixed amplitude screening; no EOG regression or adaptive rejection.'])
    (OUT / 'causal_results.json').write_text(json.dumps(report, indent=2), encoding='utf-8')
    with (OUT / 'causal_predictions.csv').open('w', newline='', encoding='utf-8') as f:
        writer = csv.DictWriter(f, fieldnames=predictions[0].keys())
        writer.writeheader()
        writer.writerows(predictions)
    np.save(OUT / 'causal_permutation_aucs.npy', null)
    ax.plot([0, 1], [0, 1], '--', color='gray', label='Chance reference (AUROC 0.50)')
    ax.set(xlabel='False-positive rate (successful flips flagged as failures)',
           ylabel='True-positive rate (failed flips detected)', xlim=(0, 1), ylim=(0, 1.02),
           title='Flip Cup: prediction on a held-out recording session')
    ax.legend(loc='lower right')
    fig.supxlabel(f'1.5 s pre-cue EEG · causal filtering · one participant\nMean session AUROC {observed:.3f}; exploratory permutation p = {pvalue:.3f}', fontsize=10)
    for ext in ('png', 'svg'):
        fig.savefig(OUT / f'flipcup_roc.{ext}', dpi=220)
    print(f'Mean session AUROC={observed:.3f}; permutation p={pvalue:.4f}', flush=True)


if __name__ == '__main__':
    main()
