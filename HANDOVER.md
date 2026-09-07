# Task ↔ loop interface

Everything you need to build the flanker task without waiting for the EEG
pipeline, the model, or the amplifier.

## The whole contract

```python
from neuroloop.loop import MockEngine

engine = MockEngine(seed=0)      # swap for LiveEngine on build day, no other change
engine.start()
engine.calibrate(seconds=120)    # blocking; run the baseline block here

for trial in trials:
    s = engine.state()           # never blocks
    if s.intervene and s.usable:
        show_reset_cue(1.5)      # this is the intervention

    onset = present_stimulus(trial)
    engine.mark(1, "stimulus")

    rt, correct = collect_response()
    engine.mark(2, "response")
    log_row(trial, onset, rt, correct, s.lapse_probability, s.intervene, s.status)

engine.stop()
```

That is the entire surface. Four methods.

## Rules

**Poll, never wait for a callback.** Call `state()` just before presenting a
stimulus. It returns a cached value immediately — no network, no compute — so
it cannot disturb PsychoPy's timing.

**Always check `status` before acting.** Three values:

| status | meaning | what to do |
|---|---|---|
| `ok` | fresh estimate | act on `intervene` |
| `stale` | data gap, estimate is old | do **not** intervene; run the trial normally |
| `uncalibrated` | `calibrate()` not run yet | do not intervene |

Never intervene on a non-`ok` status. A reset cue triggered by a dropped LSL
packet is worse than no cue at all.

**Log `lapse_probability`, `intervene` and `status` on every trial**, even
when nothing happens. The feedback-ON vs feedback-OFF comparison is the demo,
and it cannot be reconstructed afterwards if these are missing.

## Task spec

Match COG-BCI exactly — the pre-trained model does not transfer otherwise:

```
120 trials per block, 2000 ms ISI
16 ms stimulus, 2500 ± 250 ms response window, 500 ms feedback
congruent / incongruent / neutral
```

Per-trial log columns:

```
trial_index, congruency, stimulus_onset, rt, correct,
lapse_probability, intervene, status
```

Run at least one block with interventions **disabled** (`engine` ignored) as
the control condition.

## The intervention

When `intervene` is true, withhold the next stimulus and show a reset cue for
~1.5 s before continuing. That is the "slow down" — we are literally slowing
the person down, and it avoids trying to render a warning inside the few
hundred ms before an already-scheduled stimulus.

Keep it as one function, `show_reset_cue(seconds)`, so the wording and visuals
can change without touching the loop.

## Testing without hardware

`MockEngine` drifts its probability on a slow random walk, so interventions
arrive in clusters rather than uniformly — that is what the real signal is
expected to look like, and it will exercise your handling of several
interventions in a row.

- `MockEngine(seed=0)` — reproducible runs
- `MockEngine(threshold=0.3)` — frequent interventions, for testing the cue
- `MockEngine(threshold=0.95)` — almost none, for testing the control block
- `MockEngine(stale_rate=0.5)` — forces the `stale` path

If your task works against all four, it will work against the real engine.

## What you do NOT need to touch

Nothing in `neuroloop/` except `loop.py`. The DSP, thresholds, and normaliser
carry invariants (offline/online parity, canonical feature order) that break
silently — leave them to the pipeline owner.

## Open question

Waiting on ANT: whether markers go into the amplifier over a hardware trigger
input or are aligned via LSL timestamps. If it is hardware, `mark()` also
needs to fire that trigger — the call site in your task will not change either
way, so this does not block you.
