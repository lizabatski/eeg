"""
Step 2 -- does pre-cue EEG predict whether the upcoming attempt fails?

Team <NUMBER>: <MEMBER NAMES>
NOVA Buildathon 2026 / ANT Neuro challenge.

WHAT THIS TESTS
---------------
The flip-cup recording is a structural twin of the flanker task we will run on
build day: a cue marker, a clean pre-stimulus window before it, and a binary
outcome after it. Only the stimulus differs. So every component exercised
here -- epoching on the pre-cue window, feature extraction, per-session
normalisation, cross-validated classification -- is the component that will
run live, and validating it now means build day is a data-collection problem
rather than a software problem.

The scientific question is the one our product rests on: **is there
information in the seconds before a cue about whether the attempt will
succeed?**

METHODOLOGY, AND WHY IT IS STRICT
---------------------------------
With 100 trials from one person it is trivially easy to fool yourself. Four
safeguards, all of which can only make the reported numbers *worse*:

1. **No peeking.** The analysis window ends at the cue marker. Nothing after
   it enters the features -- otherwise the model sees the outcome it is meant
   to predict.

2. **Scaling inside the fold.** Normalisation is a ``Pipeline`` step, so each
   fold's scaler is fitted on training trials only. Scaling before splitting
   would leak test-set statistics and inflate the score.

3. **A real baseline.** Accuracy is meaningless under class imbalance -- the
   sessions are 32% and 52% success. Every number is reported against the
   majority-class rate, and the headline metric is ROC AUC, which is
   insensitive to base rate.

4. **A permutation test.** Labels are shuffled and the whole pipeline refit
   many times to build the null distribution of AUC. This is the check that
   catches subtle leakage and small-sample optimism: if the real AUC sits
   inside the shuffled distribution, we have nothing, however good the raw
   number looks.

We also report leave-one-session-out, which is the harder and more honest
generalisation test: train on one session, predict the other.

POSITIVE CLASS
--------------
The positive class is **failure** (a missed flip, marker 8), because that is
what the product predicts and intervenes on.

WHAT WE ACTUALLY FOUND
----------------------
Recorded here so the result is not quietly restated later as something
stronger than it was.

* At the pre-registered 1.5 s window the result is a **clean null**:
  pooled AUC 0.39, permutation p = 0.88. No pre-cue signal.

* Sweeping window length and offset (24 configurations) shows AUC rising
  coherently with window length -- about 0.50 at 0.5-1.5 s, 0.60 at 3 s,
  0.66 at 4 s. The trend is orderly rather than scattered, which is what a
  real effect buried in estimator noise looks like: longer windows give more
  stable band-power estimates.

* The best configuration (4 s ending at the cue) reaches AUC 0.657,
  permutation p = 0.024 uncorrected. But it was *selected* on the same data,
  and correcting for the 24 configurations tried gives p = 0.56. **We cannot
  claim significance.**

* The more persuasive number is leave-one-session-out at that window: AUC
  0.596 and 0.606, in both directions. Training on one session and predicting
  the other is not helped by class imbalance, and both held-out sessions land
  near 0.60.

Verdict: **suggestive, not established.** Honest framing for the pitch is
"the architecture is validated end to end, and the reference data hints at a
slow-drifting attentional signal that our flanker protocol is designed to
measure properly" -- not "we predict failure at 66%".

The design consequence matters more than the p-value: the information appears
to live in a **slow** state spanning seconds, not a fast pre-stimulus
transient. COG-BCI's flanker has a 2000 ms inter-stimulus interval, so a 4 s
window cannot fit inside one trial and the live system must track a running
estimate that spans trials rather than resetting each trial.

RUN
    python scripts/02_train_flipcup.py
"""

from __future__ import annotations

import sys
from pathlib import Path

import numpy as np
from sklearn.dummy import DummyClassifier
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score, roc_auc_score
from sklearn.model_selection import (
    StratifiedKFold,
    cross_val_predict,
    permutation_test_score,
)
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import StandardScaler

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from neuroloop import features, io  # noqa: E402

EEG_DIR = Path("EEG_flipcup")
SESSIONS = {
    1: "Ewing_Patrick_2026-08-10_13-07-25_session-01.cnt",
    2: "Ewing_Patrick_2026-08-10_13-07-25_session-02.cnt",
}

CUE_CODE = "2"       # the beep telling the subject to flip
MADE_CODE = "4"      # cup landed upright
MISSED_CODE = "8"    # cup did not land upright

#: Length of the pre-cue analysis window, in seconds. Verified to sit entirely
#: inside the waiting period on every trial of both sessions.
WINDOW = 1.5

#: Folds for within-session cross-validation. Five keeps ~10 test trials per
#: fold at n=50, which is already small; more folds would make each estimate
#: noisier still.
N_FOLDS = 5

N_PERMUTATIONS = 1000
RANDOM_STATE = 0


def build_model() -> Pipeline:
    """Scaler + L2 logistic regression.

    Logistic regression is chosen over anything fancier on purpose. With ~50
    trials and 11 features, a flexible model would memorise the training set,
    and we would learn nothing about whether the *signal* exists. It is also
    directly interpretable -- the coefficients say which rhythm carried the
    information, which is what we need on a slide.

    ``class_weight="balanced"`` stops the model from simply predicting the
    majority class in the imbalanced session.
    """
    return Pipeline([
        ("scale", StandardScaler()),
        ("clf", LogisticRegression(
            max_iter=2000,
            class_weight="balanced",
            random_state=RANDOM_STATE,
        )),
    ])


def load_session(
    number: int,
    filename: str,
    window: float = WINDOW,
    gap: float = 0.0,
    raw: "object | None" = None,
) -> tuple[np.ndarray, np.ndarray, int]:
    """Extract the pre-cue feature matrix and failure labels for one session.

    Parameters
    ----------
    number, filename
        Session number and ``.cnt`` filename.
    window
        Length of the pre-cue analysis window, in seconds.
    gap
        Seconds to stop *before* the cue. A non-zero gap tests whether the
        information is genuinely anticipatory rather than leaking from
        activity time-locked to the cue itself.
    raw
        Pre-loaded recording, to avoid re-reading the file during a sweep.

    Returns
    -------
    X
        ``(n_trials, n_features)`` feature matrix.
    y
        ``(n_trials,)`` labels, 1 = missed (failure), 0 = made.
    dropped
        Number of trials rejected as artefact-contaminated.
    """
    if raw is None:
        raw = io.load_cnt(EEG_DIR / filename)
    ch_names = io.channel_names(raw)
    sfreq = raw.info["sfreq"]

    cues = io.marker_onsets(raw, CUE_CODE)
    made = io.marker_onsets(raw, MADE_CODE)
    missed = io.marker_onsets(raw, MISSED_CODE)

    # Label each cue by whichever outcome marker follows it first.
    outcomes = sorted(
        [(t, 0) for t in made] + [(t, 1) for t in missed]
    )

    rows, labels, dropped = [], [], 0
    for cue in cues:
        later = [lab for t, lab in outcomes if t > cue]
        if not later:
            continue  # cue with no recorded outcome; skip rather than guess
        win = io.window_around(raw, stop_time=float(cue) - gap, length=window)
        if win is None:
            continue
        if not features.window_is_clean(win, ch_names):
            dropped += 1
            continue
        feats = features.extract_features(win, sfreq, ch_names)
        rows.append(features.features_to_vector(feats))
        labels.append(later[0])

    return np.array(rows), np.array(labels), dropped


def evaluate(X: np.ndarray, y: np.ndarray, label: str) -> None:
    """Cross-validate within one dataset and print an honest scorecard."""
    n_fail = int(y.sum())
    majority = max(y.mean(), 1 - y.mean())

    print(f"\n--- {label} ---")
    print(f"  {len(y)} trials: {n_fail} failures, {len(y) - n_fail} successes")
    print(f"  majority-class accuracy (the number to beat): {majority:.1%}")

    if n_fail < N_FOLDS or (len(y) - n_fail) < N_FOLDS:
        print("  too few trials in one class to cross-validate; skipping")
        return

    cv = StratifiedKFold(n_splits=N_FOLDS, shuffle=True, random_state=RANDOM_STATE)
    model = build_model()

    proba = cross_val_predict(model, X, y, cv=cv, method="predict_proba")[:, 1]
    auc = roc_auc_score(y, proba)
    acc = accuracy_score(y, (proba > 0.5).astype(int))

    dummy = DummyClassifier(strategy="most_frequent")
    dummy_acc = cross_val_predict(dummy, X, y, cv=cv).astype(int)

    print(f"  cross-validated accuracy : {acc:.1%}  "
          f"(dummy {accuracy_score(y, dummy_acc):.1%})")
    print(f"  cross-validated ROC AUC  : {auc:.3f}  (chance 0.500)")

    # The decisive test.
    score, perm_scores, pvalue = permutation_test_score(
        model, X, y,
        scoring="roc_auc",
        cv=cv,
        n_permutations=N_PERMUTATIONS,
        random_state=RANDOM_STATE,
        n_jobs=-1,
    )
    print(f"  permutation test         : p = {pvalue:.4f} "
          f"({N_PERMUTATIONS} shuffles, null AUC "
          f"{perm_scores.mean():.3f} +/- {perm_scores.std():.3f})")

    if pvalue < 0.05:
        print("  => significant: there is real pre-cue information here.")
    else:
        print("  => NOT significant: consistent with no pre-cue signal.")


def sweep_windows(raws: dict) -> None:
    """Scan window length and pre-cue gap, reporting pooled cross-validated AUC.

    This is exploratory, and labelled as such wherever its output is used. The
    maximum of many noisy estimates is biased upward, so the best cell here is
    *not* a result -- the shape of the surface is. A coherent trend across
    neighbouring cells is evidence; an isolated high cell is noise.
    """
    gaps = [0.0, 0.25, 0.5, 1.0]
    lengths = [0.5, 1.0, 1.5, 2.0, 3.0, 4.0]

    print("\n--- exploratory sweep: pooled 5-fold CV AUC (chance 0.500) ---")
    print("rows = window length, columns = gap before cue")
    print(f"{'len\\gap':<9}" + "".join(f"{str(g) + 's':>9}" for g in gaps))

    for length in lengths:
        cells = []
        for gap in gaps:
            X_parts, y_parts = [], []
            for number, filename in SESSIONS.items():
                X, y, _ = load_session(
                    number, filename, window=length, gap=gap, raw=raws[number]
                )
                X_parts.append(X)
                y_parts.append(y)
            X = np.vstack(X_parts)
            y = np.concatenate(y_parts)
            cv = StratifiedKFold(N_FOLDS, shuffle=True, random_state=RANDOM_STATE)
            proba = cross_val_predict(
                build_model(), X, y, cv=cv, method="predict_proba"
            )[:, 1]
            cells.append(roc_auc_score(y, proba))
        print(f"{length:<9.1f}" + "".join(f"{c:>9.3f}" for c in cells))

    print("\n  NOTE: the best cell is the maximum of "
          f"{len(lengths) * len(gaps)} estimates and is biased upward.")
    print("  Read the trend, not the peak.")


def main() -> int:
    if not EEG_DIR.exists():
        print(f"ERROR: cannot find {EEG_DIR}", file=sys.stderr)
        return 1

    print(f"pre-cue window: {WINDOW}s ending at the cue marker")
    print(f"features: {', '.join(features.FEATURE_NAMES)}")

    raws = {n: io.load_cnt(EEG_DIR / f) for n, f in SESSIONS.items()}

    data = {}
    for number, filename in SESSIONS.items():
        X, y, dropped = load_session(number, filename, raw=raws[number])
        data[number] = (X, y)
        print(f"\nsession {number}: {len(y)} usable trials "
              f"({dropped} dropped as artefact)")

    for number, (X, y) in data.items():
        evaluate(X, y, f"session {number}, within-session {N_FOLDS}-fold CV")

    X_all = np.vstack([X for X, _ in data.values()])
    y_all = np.concatenate([y for _, y in data.values()])
    evaluate(X_all, y_all, f"both sessions pooled, {N_FOLDS}-fold CV")

    # Leave-one-session-out: the honest generalisation test.
    print("\n--- leave-one-session-out ---")
    for held_out in data:
        train = [n for n in data if n != held_out]
        X_tr = np.vstack([data[n][0] for n in train])
        y_tr = np.concatenate([data[n][1] for n in train])
        X_te, y_te = data[held_out]

        model = build_model().fit(X_tr, y_tr)
        proba = model.predict_proba(X_te)[:, 1]
        auc = roc_auc_score(y_te, proba)
        acc = accuracy_score(y_te, (proba > 0.5).astype(int))
        majority = max(y_te.mean(), 1 - y_te.mean())
        print(f"  train {train} -> test session {held_out}: "
              f"AUC {auc:.3f}, accuracy {acc:.1%} (majority {majority:.1%})")

    sweep_windows(raws)

    # Which rhythms carried the information, for the slide.
    model = build_model().fit(X_all, y_all)
    coefs = model.named_steps["clf"].coef_[0]
    order = np.argsort(np.abs(coefs))[::-1]
    print("\n--- strongest features (pooled fit, positive = predicts FAILURE) ---")
    for i in order[:5]:
        print(f"  {features.FEATURE_NAMES[i]:>22}  {coefs[i]:+.3f}")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
