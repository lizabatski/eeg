# Frontend task: the flanker task itself

## What you're building

The actual on-screen task the subject does during the live EEG recording:
flash a stimulus (congruent / incongruent / neutral arrows), collect their
response, and — when the EEG side says the person is about to lapse — pause
and show a reset cue instead of the next stimulus. This is the closed loop:
EEG → state estimate → intervention → changed behaviour.

This is a **separate deliverable from the EEG visualization dashboard**
([FRONTEND_HANDOFF.md](FRONTEND_HANDOFF.md)). That one is a web page showing
the audience a chart of the EEG state. This one is the task itself, and it
runs in its own window — the two don't need to share a codebase, a process,
or even a machine.

**Build this in PsychoPy (Python), not the browser.** Two reasons:
1. Timing has to be accurate to the millisecond — the whole prediction
   depends on knowing exactly when each stimulus appeared relative to the EEG
   samples. Browser rendering (DOM/requestAnimationFrame) has more jitter
   than a tool built for psychophysics timing.
2. The pilot task (flip-cup, see `Behavioral Data/`) was already built this
   way, and the interface you're coding against (`neuroloop/loop.py`) is
   written assuming this style of call.

`psychopy` is **not yet in `requirements.txt`** — you'll need to add it to
your environment. It has a heavy, sometimes finicky dependency chain on
Windows; if it conflicts with the pinned `numpy`/`pandas` versions already in
the venv, flag it rather than silently downgrading something the EEG pipeline
depends on.

## The whole contract

Everything you need to build and fully test this without the EEG pipeline,
the trained model, or the amplifier being ready. This is defined in
[`neuroloop/loop.py`](neuroloop/loop.py) and documented in
[HANDOVER.md](HANDOVER.md); repeated here for the full picture:

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

Four methods total: `start()`, `calibrate(seconds)`, `state()`, `mark(code,
label)`, `stop()`. You write everything else — trial sequencing, stimulus
rendering, response collection, logging, the cue itself.

### `state()` return value

```python
@dataclass(frozen=True)
class LoopState:
    lapse_probability: float
    intervene: bool
    status: str          # "ok" | "stale" | "uncalibrated"
    n_windows: int        # windows seen since start, for logging only

    @property
    def usable(self) -> bool:
        return self.status == "ok"
```

## Rules

- **Poll, never wait for a callback.** Call `state()` immediately before
  presenting each stimulus. It returns a cached value instantly — no
  network, no compute — so it cannot disturb your trial timing.
- **Always gate on `status`, never act on a non-`ok` status:**

  | status | meaning | what to do |
  | --- | --- | --- |
  | `ok` | fresh estimate | act on `intervene` |
  | `stale` | data gap, estimate is old | do **not** intervene; run the trial normally |
  | `uncalibrated` | `calibrate()` hasn't finished | do not intervene |

  A reset cue triggered by a dropped data packet is worse than no cue at
  all — this is a hard rule, not a style preference.
- **Log `lapse_probability`, `intervene`, and `status` on every single
  trial**, even the ones where nothing happens. The feedback-ON vs.
  feedback-OFF comparison is the demo's main result, and it can't be
  reconstructed afterward if these are missing from any row.
- **Run at least one full block with interventions disabled** (ignore
  `engine` output entirely) as the control condition. Feedback ON vs OFF is
  what the demo shows changing, not raw accuracy.

## Task timing spec

Match COG-BCI's protocol exactly — the pre-trained model does not transfer
to a different timing structure:

- **120 trials per block**
- **2000 ms ISI** (inter-stimulus interval)
- **16 ms stimulus** duration
- **2500 ± 250 ms response window**
- **500 ms feedback**
- conditions: **congruent / incongruent / neutral**
- **2–3 min calibration block first** (`engine.calibrate(...)`) — absolute
  alpha power varies several-fold between people, so this is not optional
  warm-up, it's what makes the per-person baseline valid at all

## The intervention

When `intervene` is `true` (and `status == "ok"`): withhold the next
stimulus, show a reset cue for **~1.5 s**, then continue to the next trial.
That's the entire "slow down" mechanic — we're literally pausing the person,
not trying to squeeze a warning into the few hundred ms before a
stimulus that's already scheduled to appear.

Implement this as one function, `show_reset_cue(seconds)`, so wording and
visuals can change later without touching the trial loop.

## Per-trial log columns

```
trial_index, congruency, stimulus_onset, rt, correct,
lapse_probability, intervene, status
```

Write one row per trial regardless of whether an intervention happened.

## Marker / trigger codes

For alignment with the EEG recording (`engine.mark(code, label)`) and for
consistency with the COG-BCI reference data your model is trained on, use
these codes from `data/cogbci/triggerlist.txt`:

| code | meaning |
| --- | --- |
| `20` | FLANKER Start |
| `21` | FLANKER End |
| `210` | Trial / ISI Start |
| `23` | Fixation Cross |
| `241` | Stimulus, congruent |
| `242` | Stimulus, incongruent |
| `2511` / `2512` | Response Correct, congruent / incongruent |
| `2521` / `2522` | Response Incorrect, congruent / incongruent |
| `25121` / `25122` | Correct-response feedback, congruent / incongruent |
| `25221` / `25222` | Incorrect-response feedback, congruent / incongruent |
| `25321` / `25322` | Missed-response feedback, congruent / incongruent |

**Open item — flag, don't guess:** this reference trigger list only defines
congruent/incongruent codes, not a distinct neutral code, even though the
build-day protocol calls for congruent/incongruent/neutral. Check with the
pipeline owner on which code to log neutral trials under before build day —
don't invent one, since it needs to match what the offline model expects.

## Testing without hardware

`MockEngine` drifts its probability on a slow random walk on purpose, so
interventions cluster rather than landing uniformly at random — that's what
the real signal is expected to look like, and it will exercise your handling
of several interventions in a row.

- `MockEngine(seed=0)` — reproducible runs, good for automated checks
- `MockEngine(threshold=0.3)` — frequent interventions, for testing the cue path
- `MockEngine(threshold=0.95)` — almost none, for testing the control block
- `MockEngine(stale_rate=0.5)` — forces the `stale` path, so you can verify
  you correctly suppress interventions on stale data

If your task behaves correctly against all four, it will work against the
real engine on build day — `LiveEngine` swaps in with no task code changes.

## What you do NOT need to touch

Nothing in `neuroloop/` except `loop.py`. The DSP, artefact thresholds, and
normaliser carry invariants (offline/online parity, canonical feature order)
that break silently if touched — leave them to the pipeline owner.

## Open question (does not block you)

Waiting on ANT: whether markers go into the amplifier via a hardware trigger
input or are aligned via LSL timestamps afterward. If it's hardware,
`mark()` will also need to fire that trigger internally — but the call site
in your task (`engine.mark(code, label)`) does not change either way, so
this has no effect on how you build the task.

## Acceptance criteria

- [ ] Runs a full 120-trial block against `MockEngine` end-to-end with correct timing (2000ms ISI, 16ms stimulus, 2500±250ms response window, 500ms feedback)
- [ ] Presents congruent / incongruent / neutral conditions
- [ ] Calls `calibrate()` once, blocking, before any trials run
- [ ] Polls `state()` immediately before each stimulus, never blocks on it
- [ ] Only acts on `intervene` when `status == "ok"`; never intervenes on `stale` or `uncalibrated`
- [ ] Withholds the next stimulus and shows the reset cue for 1.5s when triggered, via a single `show_reset_cue(seconds)` function
- [ ] Logs every trial (including no-op ones) with all required columns
- [ ] Supports running a block with interventions disabled (control condition)
- [ ] Verified against all four `MockEngine` configurations above
- [ ] Calls `mark()` with the correct trigger codes at stimulus onset and response

Questions on anything above → ask before guessing, especially the neutral
trigger code and the `stale`/`uncalibrated` gating — those are the two
places a wrong assumption would silently corrupt the demo's main result.
