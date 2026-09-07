# NeuroLoop

Team `<NUMBER>`: `<MEMBER NAMES>`
NOVA Buildathon 2026 — ANT Neuro challenge.

A closed-loop EEG system that predicts an attentional lapse before it happens
and tells the user to slow down.

## The idea

On build day we run an **Eriksen flanker task** while recording EEG. The system
watches two well-established markers in the pre-stimulus window:

- **posterior alpha (8–13 Hz)** rising → attention disengaging
- **frontal midline theta (4–8 Hz)** falling → weaker cognitive control

When the combination crosses a threshold, the system **withholds the next
stimulus** and shows a reset cue — literally slowing the user down. That is
the closed loop: EEG → state estimate → intervention → changed behaviour →
changed EEG.

### Why flanker, and why the build-day task matches the training task

We train on the COG-BCI flanker data (29 subjects × 3 sessions, ~10,400
trials) and run **the same paradigm** on build day. That alignment is the
point: it lets us walk in with a model already fitted on 87 sessions and need
only a 2-minute calibration block per person.

The alternative — train on flanker, demo on Stroop — assumes a task transfer
we could not validate beforehand. And training from scratch on the 15–20
minutes of data a build-day session yields is roughly the situation that
produced the null on flip-cup.

Matching COG-BCI's timing is therefore load-bearing, not cosmetic.

### We predict lapses, not errors

Flanker error rates are ~5–10%, so a 120-trial block yields ~10 errors —
nowhere near enough to train or honestly evaluate a classifier. The target is
therefore a **lapse**: `error OR reaction time above the person's 75th
percentile`. That gives ~25–30% positives, hundreds of them, and RT is
continuous so it can also be regressed on directly. "You're about to be slow"
is the same product message as "you're about to make a mistake".

## Layout

```
neuroloop/
  features.py    core DSP, adaptive artefact thresholds, EOG regression
                 — shared byte-for-byte by offline and live paths
  io.py          ANT .cnt loading and pre-cue epoching (offline only)
  normalise.py   per-person calibration (frozen baseline z-scoring)
scripts/
  01_validate_spectral.py     proves the DSP is correct
  02_train_flipcup.py         does pre-cue EEG predict failure?
  03_calibrate_thresholds.py  fits artefact thresholds per session
```

`features.py` deliberately has **no MNE import**. It takes a plain
`(n_channels, n_samples)` array so the offline trainer and the live LSL loop
run identical code. If the two paths diverged, the model would be fed subtly
different numbers online and degrade silently — invisible until demo day.

## Results so far

### Step 1 — spectral pipeline validated ✅

Tested against the most reliable effect in EEG: eyes-closed occipital alpha.
The `EO-EC` file is really an auditory oddball task; the four 20 s rest blocks
(markers 13→14) are all eyes-closed, and the task blocks (11→12) are the
eyes-open comparison.

```
eyes closed : -0.158    eyes open : -0.883
fold change : 5.31x     Cohen's d : 4.17
```

Right direction, right magnitude. The DSP is trustworthy.

### Step 2 — pre-cue prediction on flip-cup: suggestive, not established ⚠️

The flip-cup recording is a structural twin of the flanker task: cue marker,
clean pre-stimulus window, binary outcome.

| analysis | result |
|---|---|
| 1.5 s window (pre-registered) | AUC 0.39, permutation p = 0.88 — **clean null** |
| sweep over 24 window/gap configs | AUC rises with window length: ~0.50 at 0.5–1.5 s, 0.60 at 3 s, 0.66 at 4 s |
| best config (4 s), permutation | p = 0.024 uncorrected, **p = 0.56 after Bonferroni ×24** |
| best config, leave-one-session-out | AUC 0.596 and 0.606, both directions |

(Numbers above predate the EOG filter fix; after it the sweep peaks at 0.690
and the 1.5 s null is unchanged. Conclusions are the same.)

**Verdict: suggestive, not established.** We cannot claim significance. The
most persuasive number is leave-one-session-out at ~0.60 in both directions,
which class imbalance cannot explain. Honest pitch framing is "the
architecture is validated end to end and the reference data hints at a slow
attentional signal" — not "we predict failure at 66%".

Why the null is unsurprising: n=50 per session is very small, and flip-cup
outcome is dominated by *motor* execution noise (wrist, cup, table) rather
than attention. Flanker fixes both — ~10,400 trials across COG-BCI, and errors
that are overwhelmingly attentional.

### The design consequence that matters more than the p-value

The information lives in a **slow** state spanning seconds, not a fast
pre-stimulus transient — that is what the monotonic rise with window length
means. COG-BCI's flanker has a **2000 ms ISI**, so a 4 s window cannot fit
inside one trial.

So the live system must track a **running estimate that spans trials** (an
exponential moving average of band power) rather than resetting each trial.
This is not an optimisation: evaluating only inside a single 2 s gap tests the
configuration that already came out null.

## Build-day protocol

Match the COG-BCI flanker timing exactly, or the pre-trained model does not
apply:

- 120 trials per block, **2000 ms ISI**
- 16 ms stimulus, 2500 ± 250 ms response window, 500 ms feedback
- congruent / incongruent / neutral
- **2–3 min calibration block first** — absolute alpha varies several-fold
  between people, so all features are z-scored against the user's own baseline.
  The artefact thresholds and EOG coefficients are fitted here too.
- Feedback **ON vs OFF** blocks, to show error rate / RT variability dropping
  with the loop closed. A before/after from a live n=1 beats any accuracy
  number on a slide.

**Fallback:** also fit a within-session model on build-day data. Cross-*amplifier*
transfer (ActiCHamp → ANT, different montage and reference) is not guaranteed,
so do not bet the demo on the pre-trained model alone.

**Testable now:** train on COG-BCI subjects 1–20, test on 21–29. If
cross-subject transfer holds within COG-BCI, cross-amplifier has a real chance.
If it does not, we learn that before Sept 12.

### Open question for the ANT mentors

How do we get triggers into the amplifier? Hardware trigger input is much
cleaner than aligning task and EEG via LSL timestamps, and marker timing
accuracy is the difference between a clean pre-stimulus epoch and mush.

## Running

```bash
python scripts/01_validate_spectral.py   # must pass before trusting anything
python scripts/02_train_flipcup.py       # ~2 min (permutation tests)
```

## Notes on the provided data

- Drop `M1`/`M2` — recorded but never connected (organiser's `notes.docx`)
- Artefact screening checks **only the feature channels** plus EOG. Screening
  all 64 rejected 46% of windows: in a large montage some electrode is always
  poor, and noise on a channel we never read cannot corrupt a feature we never
  compute. Restricting it took the drop rate to 0.5%.
- **Filter the EOG channel explicitly.** `raw.filter()` defaults to EEG picks
  only, so once EOG is typed as `eog` it is silently left unfiltered and
  drift-dominated (std 98 µV vs 42 µV filtered). This broke EOG regression
  entirely and made every EOG amplitude threshold measure drift rather than
  blinks. Fixed in `io.load_cnt` by passing explicit picks.
- Artefact thresholds are fitted per channel from the calibration block
  (`AdaptiveRejector`), not hard-coded. Fz differs 1.77× between two sessions
  of the same person on the same day — no constant can be right for both.
- Ocular correction (`EOGRegressor`) is only **partially** effective here:
  blink-driven inflation of frontal p2p drops 67% → 57%, and the theta-feature
  gap by ~22%. One EOG channel cannot capture both vertical and horizontal
  components. So `eog_ptp` is also carried as a *declared* feature, letting the
  model account for residual contamination explicitly instead of being fooled
  by it. It lands third-strongest in the pooled fit.
- Session 1 is 16/50 successes, session 2 is 26/50 — hit rate differs a lot,
  so session is a confound. Hence within-session CV and leave-one-session-out.
- `notes.docx` says the waiting period is jittered 7.5–16.5 s; in session 1 it
  is actually ~7.5 s flat. Check the data, not the notes.
