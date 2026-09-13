"""Recompute held-out predictions and export the deployed cohort's ROC plot.

Team: Monster's Inc

Re-runs the same leave-one-participant-out evaluation as
:func:`neuroloop.cogbci_model.train_cogbci_model` (refit on every other
participant, predict the held-out one) directly from the deployed model's
manifest, so the exported ROC curves and mean AUROC are guaranteed to match
what is actually deployed (checked with an ``assert`` against the manifest's
recorded mean AUROC) rather than being computed from a possibly-stale cached
result.
"""
import json
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np
from sklearn.metrics import roc_curve, roc_auc_score
from neuroloop.cogbci_model import load_flanker_session, _subject_arrays
from neuroloop.live_model import build_pipeline


def main():
    manifest = json.loads((ROOT / "artifacts/cogbci_flanker_live_model.json").read_text())
    evaluation = manifest["evaluation"]
    arrays = {}
    for subject in evaluation["training_subjects"]:
        rows = []
        for path in sorted((ROOT / "data/cogbci" / f"sub-{subject:02}").glob("ses-S*/eeg/Flanker.set")):
            rows.extend(load_flanker_session(path, subject=subject))
        arrays[subject] = _subject_arrays(rows)
        print(f"Loaded participant {subject}", flush=True)
    grid = np.linspace(0, 1, 501)
    curves, scores, predictions = [], [], []
    fig, ax = plt.subplots(figsize=(8, 7))
    for subject, (test_x, test_y, _) in arrays.items():
        train = [v for s, v in arrays.items() if s != subject]
        model = build_pipeline().fit(np.vstack([v[0] for v in train]), np.concatenate([v[1] for v in train]))
        probability = model.predict_proba(test_x)[:, 1]
        fpr, tpr, _ = roc_curve(test_y, probability)
        score = roc_auc_score(test_y, probability)
        scores.append(score)
        curves.append(np.interp(grid, fpr, tpr))
        ax.plot(fpr, tpr, color="#9baec4", alpha=0.45, linewidth=1)
        predictions.extend((subject, int(y), float(p)) for y, p in zip(test_y, probability))
    assert np.isclose(np.mean(scores), evaluation["mean_auc"])
    ax.plot(grid, np.mean(curves, axis=0), color="#2563eb", linewidth=3,
            label=f"Mean ROC across participants (mean AUROC = {np.mean(scores):.3f})")
    ax.plot([], [], color="#9baec4", linewidth=1, label="Individual held-out participants")
    ax.plot([0, 1], [0, 1], "--", color="#555555", linewidth=1.5, label="Chance (AUROC = 0.500)")
    ax.set(xlim=(0, 1), ylim=(0, 1.01), xlabel="False positive rate", ylabel="True positive rate",
           title=f"Predicting attention lapses from pre-stimulus EEG\nLeave-one-participant-out validation · {len(arrays)} participants")
    ax.legend(loc="lower right", fontsize=9)
    ax.spines[["top", "right"]].set_visible(False)
    ax.grid(alpha=0.15)
    fig.text(0.5, 0.025, f"Logistic regression · {len(predictions):,} retained trials · Performance approximately at chance", ha="center", fontsize=10)
    fig.tight_layout(rect=(0, 0.055, 1, 1))
    for extension in ("png", "svg", "pdf"):
        fig.savefig(ROOT / "results" / f"cogbci_12_roc.{extension}", dpi=300, bbox_inches="tight")
    np.savetxt(ROOT / "results/cogbci_12_held_out_predictions.csv", predictions,
               delimiter=",", header="subject,lapse,predicted_score", comments="", fmt=["%d", "%d", "%.12g"])
    print(f"Saved ROC plots. Mean AUROC: {np.mean(scores):.6f}")


if __name__ == "__main__":
    main()
