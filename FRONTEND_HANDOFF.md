# EEG terminal demo and frontend contract

Run from the project root in PowerShell:

```powershell
$env:MNE_LOGGING_LEVEL='WARNING'
.\.venv\Scripts\python.exe scripts/04_terminal_demo.py
```

This replays actual Flip Cup session 1 EEG at recording speed for 90 seconds.
It does not connect to hardware or predict Flip Cup outcomes. Ctrl+C stops it.
Use `--speed 4` for faster playback, `--speed 0` for fastest processing,
`--seconds 300` for a longer run, or `--file PATH` for another ANT recording.

To produce frontend fixtures:

```powershell
$env:MNE_LOGGING_LEVEL='WARNING'
.\.venv\Scripts\python.exe scripts/04_terminal_demo.py --seconds 60 --speed 0 --json > demo_states.jsonl
```

Each stdout line is one JSON snapshot. Diagnostic messages go to stderr.
PowerShell redirection may write UTF-16 on older Windows PowerShell; use
`Get-Content demo_states.jsonl` to read locally or convert to UTF-8 for the browser.
The checked-in `demo_states.jsonl` fixture is UTF-8.
There is no HTTP/WebSocket server yet. For frontend development, load the fixture
and advance one row every 500 ms; a future backend can forward the same objects.

## Build this screen

1. Persistent badge: **Recorded EEG replay**.
2. Status label and baseline progress, using `status`, `message`, and
   `baseline_windows` (target 30).
3. Line chart: recording time against `state_score_z`. Label it
   **EEG change from baseline (z-score)**. Draw a reference line at 1.5.
   Null values are gaps, not zeros. This is not a percentage or validated attention score.
4. On `status == "ok"` and `intervene == true`, show **Pause and reset**
   for 1.5 seconds. Deduplicate by `cue_id`. Subsequent snapshots must not
   dismiss the cue early. The backend enforces a 10-second recording-time cooldown.
5. On artifact or invalid baseline, suppress feedback and show the supplied message.
   After playback ends, show **Replay finished** and stop acting on the last state.
   On a future live connection, no update for 2 seconds should show **Disconnected**
   and suppress cues until fresh data arrives.

## Snapshot schema (version 1)

| Field | Meaning |
| --- | --- |
| `schema_version` | Integer, currently 1 |
| `source` | Currently `replay`; keep visibly distinct from future live data |
| `recording_time_s` | Seconds since recording start, not wall-clock time |
| `status` | `warming_up`, `calibrating`, `artifact`, `invalid_baseline`, or `ok` |
| `baseline_windows` | Number of accepted baseline windows, up to 30 |
| `alpha_posterior` | Mean log10 relative posterior alpha power, or null |
| `theta_frontal` | Mean log10 relative frontal theta power, or null |
| `state_score_z` | Standardized alpha-minus-theta contrast, or null |
| `intervene` | One-update cue event, false whenever status is not ok |
| `cue_id` | Unique within a replay run for deduplicating a cue, otherwise null |
| `message` | Human-readable status |

## What the backend actually does

Reads raw ANT data in half-second chunks, selects frontal/posterior/EOG channels,
and applies a stateful causal 1–40 Hz Butterworth filter. Extracts existing
`features.py` features from the trailing 4 seconds after fixed amplitude artifact
screening. Freezes the mean and standard deviation of the first 30 accepted
alpha-minus-theta windows. These windows overlap; they are a demo baseline,
not 30 independent observations. A score above 1.5 can emit a cue.

This is a demonstrator rule. The threshold is not validated, EOG regression and
adaptive rejection are not integrated here, and these outputs are not the old
offline classifier results. No success/failure labels enter the score.

## Hardware integration boundary

The current input is `raw.get_data(...)`, yielding channels × samples in volts.
The next backend step is to extract this processor into a reusable component and
replace file input with ANT's LSL chunks, preserving channel mapping, voltage units,
sample rate, filter state, and sample timestamps. Add disconnection handling and
event-marker transport before calling it a live engine. The frontend should
consume snapshots and never calculate EEG features itself.

This document supersedes HANDOVER.md's `lapse_probability` field for this replay
demo. The existing MockEngine/task API has not been changed.
