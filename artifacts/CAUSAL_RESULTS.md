# Flip Cup causal reanalysis

Run from the project root in Command Prompt (with the virtual environment active):

```bat
set MNE_LOGGING_LEVEL=WARNING
python scripts/06_evaluate_causal.py
```

## Slide-ready result

We tested whether 1.5 seconds of pre-cue EEG predicted Flip Cup failure.
Using causal filtering and training on one recording session to predict the
other, AUROC was 0.506 and 0.423 (50 trials per session). Mean session AUROC
was 0.464, with an exploratory within-session label-permutation p-value of
0.681 (1,000 shuffles). This analysis did not demonstrate reliable prediction
above chance. It does not establish that EEG contains no predictive information.

Insert `flipcup_roc.png` or `flipcup_roc.svg`. Each curve represents predictions
on a session excluded from model fitting. The diagonal is the chance reference.
The reported mean is the arithmetic mean of the two session AUROCs, not an
AUROC calculated by pooling scores from different models.

## What was run

- Two provided ANT Flip Cup recordings, one participant, 100 retained trials.
- Outcome labels: exactly one made (4) or missed (8) marker between cue (2)
  and the next cue; ambiguous or missing pairs are excluded. None were excluded.
- Removed M1/M2. Applied a forward-only fourth-order Butterworth 1–40 Hz filter,
  initialized from the first sample, matching the replay's filter design.
- Excluded any window starting within the first four recording seconds. None did.
- Used 1.5 seconds immediately before each cue. Fixed feature-channel amplitude
  screening: 150 microvolts EEG and 450 microvolts EOG. No trials rejected.
- Extracted 12 existing features. No EOG regression or adaptive rejection.
- StandardScaler and L2 logistic regression, balanced class weights, C=1,
  max_iter=2000, random_state=0. Scaler fitted on training session only.
- Two directions of held-out-session testing; no parameter/window sweep.
- Permuted labels separately within each session and refitted both models for
  each of 1,000 permutations. Compared the mean session AUROC using an upper-tail
  test with the +1 correction; seed 0.

Accuracy at cutoff 0.5 was 52% on session 1 and 44% on session 2. The baseline
that predicts the TRAINING session's most common class scored 32% and 48%,
respectively. The TEST sessions' majority proportions are 68% and 52%; those
are descriptive comparisons, not a baseline fitted without test labels.

## Limits and relation to earlier results

This is an exploratory reanalysis of previously inspected data. It is not a
preregistered confirmation, and does not validate new-participant prediction.
Within-session random permutations assume exchangeable labels; temporal dependence
can compromise that assumption. No uncertainty interval is claimed from only two
sessions of one participant. These results cannot identify why prediction failed
or establish that physical luck is the cause.

The older `02_train_flipcup.py` and historical README numbers use a different
filter/evaluation. The new result does not reproduce their random-fold AUROC.
Use this report for the causal, held-out-session slide. The replay chart is a
separate threshold-rule demonstration, not output of this classifier.

Artifacts: `causal_predictions.csv` contains every held-out score and label;
`causal_results.json` contains metrics and settings; `causal_permutation_aucs.npy`
contains the null scores. `flipcup_roc.png` and `.svg` are derived from the CSV's
underlying held-out predictions.

Verification: all 100 cue/outcome pairs passed alignment checks; causal filtering
matched half-second chunk processing numerically, and changing future input did
not change earlier filtered samples.
