# Frontend task: EEG replay screen

## What you're building

NeuroLoop predicts an attentional lapse before it happens and tells the user
to slow down. Your job is the live-facing screen: a badge, a status line, a
baseline progress indicator, a chart of the EEG state score, and a "Pause and
reset" cue that fires when the backend says to intervene.

There is no server yet. You build against a checked-in fixture
(`demo_states.jsonl`) of real replayed EEG, advancing one row every 500 ms.
A future backend will push the same JSON objects over HTTP/WebSocket — your
component should not need to change when that happens.

**You never calculate EEG features.** Every number you need — the score, the
status, whether to show a cue — is already computed. If something feels like
it needs more logic than "read this field and render it," that's a sign to
ask, not to add analysis on the frontend.

## Getting the fixture

Already checked into the repo at `demo_states.jsonl` (UTF-8, safe to `fetch`
or import directly). Each line is one JSON snapshot — parse as JSONL, not a
single JSON array.

If you want to regenerate it or produce a longer/shorter run, from the
project root in PowerShell:

```powershell
$env:MNE_LOGGING_LEVEL='WARNING'
.\.venv\Scripts\python.exe scripts/04_terminal_demo.py --seconds 60 --speed 0 --json > demo_states.jsonl
```

PowerShell redirection can write UTF-16 on older Windows PowerShell installs —
if you regenerate it and the browser can't parse it, re-save as UTF-8 or read
it with `Get-Content` first to check. The version already in the repo is
UTF-8 and fine to use as-is.

You can also watch the same data play out in the terminal for a sanity check:

```powershell
$env:MNE_LOGGING_LEVEL='WARNING'
.\.venv\Scripts\python.exe scripts/04_terminal_demo.py
```

This replays 90 seconds of real Flip Cup session 1 EEG at recording speed.
It does not connect to hardware and does not predict Flip Cup outcomes —
it's just the same snapshot stream you're building against, printed instead
of JSON.

## Screen spec

1. **Persistent badge**: "Recorded EEG replay". Always visible — this is
   replayed data, not live hardware, and the screen must never imply
   otherwise.
2. **Status label + baseline progress**, driven by `status`, `message`, and
   `baseline_windows` (target 30, i.e. render as *N / 30*).
3. **Line chart**: recording time (`recording_time_s`) on the x-axis,
   `state_score_z` on the y-axis. Label it "EEG change from baseline
   (z-score)". Draw a fixed reference line at **1.5**.
   - Treat `null` values as gaps in the line, not zero.
   - This is a z-score, not a percentage and not a validated attention
     score — don't add a "%" or a confidence framing anywhere near it.
4. **Intervention cue**: when `status == "ok"` and `intervene == true`, show
   "Pause and reset" for **1.5 seconds**.
   - Deduplicate by `cue_id` — the same `cue_id` must only trigger the cue
     once, even if it appears in more than one snapshot.
   - Once shown, a cue runs its full 1.5s. A later snapshot must not cut it
     short.
   - The backend enforces a 10-second cooldown between cues (recording time,
     not wall-clock), so you won't see them closer together than that — but
     don't build your own cooldown logic on top of it.
5. **Degraded states**:
   - On `status == "artifact"` or `status == "invalid_baseline"`: suppress
     any feedback/cue and show the `message` field as-is.
   - After playback ends (fixture exhausted): show "Replay finished" and
     freeze — stop reacting to the last state you received.
   - (Forward-looking, not needed for the fixture demo but keep it cheap to
     add): once this is wired to a live connection, no update for 2 seconds
     should show "Disconnected" and suppress cues until fresh data arrives.

## Snapshot schema (version 1)

| Field | Type | Meaning |
| --- | --- | --- |
| `schema_version` | int | Currently `1` |
| `source` | string | Currently `"replay"`. Keep this visibly distinct from future live data — don't hardcode "replay" into your UI copy, read it. |
| `recording_time_s` | float | Seconds since recording start. Not wall-clock time. |
| `status` | string | One of `warming_up`, `calibrating`, `artifact`, `invalid_baseline`, `ok` |
| `baseline_windows` | int | Accepted baseline windows so far, 0–30 |
| `alpha_posterior` | float \| null | Mean log10 relative posterior alpha power |
| `theta_frontal` | float \| null | Mean log10 relative frontal theta power |
| `state_score_z` | float \| null | Standardized alpha-minus-theta contrast — this is what you chart |
| `intervene` | bool | One-shot cue event; always `false` when `status != "ok"` |
| `cue_id` | string \| null | Unique within a run, for cue dedup; `null` when no cue |
| `message` | string | Human-readable status text to display |

Example line from the fixture:

```json
{"schema_version": 1, "source": "replay", "recording_time_s": 4.0, "status": "artifact", "baseline_windows": 0, "alpha_posterior": null, "theta_frontal": null, "state_score_z": null, "intervene": false, "cue_id": null, "message": "..."}
```

## Why this exists (context, not required reading to build the screen)

The backend reads raw EEG, filters it, extracts alpha/theta features, and
freezes a per-person baseline over the first 30 accepted windows. A z-score
above 1.5 can emit a cue. This threshold is a demo rule, not a validated
clinical or product threshold — hence the UI language constraints above
(no "%", no "attention score", always show the replay badge).

## Acceptance criteria

- [ ] Loads and steps through `demo_states.jsonl` one row per 500ms
- [ ] Badge, status label, and baseline progress all update live
- [ ] Chart renders `state_score_z` against `recording_time_s` with a 1.5
      reference line, and correctly gaps on `null`
- [ ] "Pause and reset" fires once per unique `cue_id`, holds for exactly
      1.5s, and is never dismissed early by a later snapshot
- [ ] `artifact` / `invalid_baseline` states suppress cues and show the
      backend's `message`
- [ ] Reaching the end of the fixture shows "Replay finished" and the screen
      stops reacting to further (absent) updates
- [ ] No frontend code computes or derives EEG values — every number comes
      from the snapshot

## What's out of scope for now

- There is no HTTP/WebSocket server yet — don't build a client for one.
  Structure your data-loading so swapping the fixture reader for a socket
  listener later is a small change, but don't build the socket layer now.
- Hardware/live-connection handling (the "Disconnected" state) — stub it
  cheaply, don't over-invest.
- This document supersedes `HANDOVER.md`'s `lapse_probability` field for this
  replay screen. The existing MockEngine/task API elsewhere in the repo is
  unrelated and unchanged.

Questions on anything above → ask before guessing, especially around the cue
dedup/cooldown logic and the null-handling in the chart — those are the two
places past mistakes have come from.
