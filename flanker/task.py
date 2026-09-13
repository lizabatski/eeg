"""COG-BCI-compatible Eriksen flanker task driven by a LoopEngine.

Team: Monster's Inc

Algorithm notes
----------------
* :func:`build_trials` generates a trial order that is balanced (equal counts
  of each of the four arrow patterns in :data:`PATTERNS`) and pseudorandom,
  but rejects orders with long runs: it shuffles with a seeded RNG up to
  10,000 times and keeps the first shuffle where no congruency condition or
  correct-response key repeats more than 4 times in a row
  (:func:`_longest_run`). A long run of the same condition or the same
  correct key would let a participant fall into a motor habit instead of
  actually reading each stimulus, which would confound reaction time with
  response strategy rather than attentional state.
* :func:`should_show_intervention` / :func:`cognitive_load_feedback` gate all
  participant-visible feedback on both the experimental condition
  (``feedback_enabled``, i.e. which block the participant is in) and the
  freshness of the engine's state (``state.status == "ok"``). A stale or
  uncalibrated engine estimate is deliberately never shown or acted on, so a
  stalled amplifier degrades to "no feedback" rather than misleading the
  participant.
* :func:`run_experiment` and :func:`_run_trial` implement the trial loop
  itself: present a fixation, poll the engine's current state
  (:meth:`~neuroloop.loop.LoopEngine.state`, which never blocks), optionally
  show a "pause and reset" cue, present the stimulus for a frame-accurate
  duration (:func:`_verify_frame_timing` measures the real display refresh
  rate rather than assuming 60 Hz, since a 16 ms stimulus is only exact if
  the frame count divides the true refresh interval evenly), collect the
  response within a jittered response window, then log every timing and
  state field needed for later analysis (:data:`CSV_FIELDS`). Event marker
  codes (:func:`stimulus_code`, :func:`response_code`, :func:`feedback_code`)
  follow the COG-BCI dataset's numbering so recordings from this task line up
  with the reference dataset's trigger scheme.
"""
from __future__ import annotations

import csv
from dataclasses import dataclass
from datetime import datetime
from pathlib import Path
import random
import re
import threading
from typing import TYPE_CHECKING, Any, Iterable

from .eeg_panel import EegPanelClient

if TYPE_CHECKING:
    from neuroloop.loop import LoopEngine, LoopState


TRIALS_PER_PATTERN = 30
CALIBRATION_SECONDS = 120.0
ISI_SECONDS = 2.0
STIMULUS_SECONDS = 0.016
RESPONSE_WINDOW_RANGE = (2.25, 2.75)
FEEDBACK_SECONDS = 0.5


@dataclass(frozen=True)
class Trial:
    pattern: str
    congruency: str
    correct_key: str


PATTERNS = (
    Trial("<<<<<", "congruent", "left"),
    Trial(">>>>>", "congruent", "right"),
    Trial("<<><<", "incongruent", "right"),
    Trial(">><>>", "incongruent", "left"),
)

CSV_FIELDS = (
    "participant",
    "engine_mode",
    "model_id",
    "classification_source",
    "block_index",
    "feedback_enabled",
    "trial_index",
    "congruency",
    "stimulus_pattern",
    "correct_key",
    "response",
    "stimulus_onset",
    "stimulus_offset",
    "response_time",
    "response_window_seconds",
    "correct",
    "lapse_probability",
    "intervene",
    "status",
    "cognitive_load",
    "guidance",
    "reset_cue_shown",
    "feedback_onset",
)


class TaskAborted(Exception):
    """Raised after the participant presses Escape."""


def _longest_run(values: Iterable[str]) -> int:
    longest = current = 0
    previous: str | None = None
    for value in values:
        current = current + 1 if value == previous else 1
        previous = value
        longest = max(longest, current)
    return longest


def build_trials(seed: int, trial_count: int = 120) -> list[Trial]:
    """Return balanced trials with no long condition or response runs."""
    if trial_count < 4 or trial_count % 2:
        raise ValueError("Trial count must be an even number of at least four")
    quotient, remainder = divmod(trial_count, len(PATTERNS))
    pattern_counts = [quotient] * len(PATTERNS)
    if remainder == 2:
        pattern_counts[0] += 1
        pattern_counts[2] += 1
    trials = [
        trial
        for trial, count in zip(PATTERNS, pattern_counts)
        for _ in range(count)
    ]
    rng = random.Random(seed)
    for _ in range(10_000):
        rng.shuffle(trials)
        if (
            _longest_run(t.congruency for t in trials) <= 4
            and _longest_run(t.correct_key for t in trials) <= 4
        ):
            return list(trials)
    raise RuntimeError("Could not construct a balanced pseudorandom trial order")


def should_show_intervention(state: LoopState, feedback_enabled: bool) -> bool:
    """Gate interventions on both the block condition and fresh engine state."""
    return feedback_enabled and state.status == "ok" and state.intervene


def cognitive_load_feedback(
    state: LoopState, feedback_enabled: bool
) -> tuple[str, str] | None:
    """Return visible binary guidance only when feedback is allowed and fresh."""
    if not feedback_enabled or state.status != "ok":
        return None
    high = state.risk_high if state.risk_high is not None else state.intervene
    return ("high", "Calm down") if high else ("low", "Proceed")


def stimulus_code(trial: Trial) -> int:
    return 241 if trial.congruency == "congruent" else 242


def response_code(trial: Trial, correct: bool) -> int:
    if correct:
        return 2511 if trial.congruency == "congruent" else 2512
    return 2521 if trial.congruency == "congruent" else 2522


def feedback_code(trial: Trial, correct: bool | None) -> int:
    if correct is None:
        return 25321 if trial.congruency == "congruent" else 25322
    if correct:
        return 25121 if trial.congruency == "congruent" else 25122
    return 25221 if trial.congruency == "congruent" else 25222


def _safe_participant_id(value: str) -> str:
    cleaned = re.sub(r"[^A-Za-z0-9_-]+", "_", value.strip())
    if not cleaned:
        raise ValueError("Participant ID must contain a letter or number")
    return cleaned


def _wait_for_continue(
    win: Any,
    keyboard: Any,
    text_stim: Any,
    message: str,
    extra_stimuli: tuple[Any, ...] = (),
) -> None:
    text_stim.text = f"{message}\n\nPress SPACE to continue."
    keyboard.clearEvents()
    while True:
        text_stim.draw()
        for extra in extra_stimuli:
            extra.draw()
        win.flip()
        keys = keyboard.getKeys(keyList=["space", "escape"], waitRelease=False)
        if any(key.name == "escape" for key in keys):
            raise TaskAborted
        if any(key.name == "space" for key in keys):
            return


def _show_for(
    win: Any,
    keyboard: Any,
    stimulus: Any,
    seconds: float,
    clock: Any,
    extra_stimuli: tuple[Any, ...] = (),
) -> float:
    clock.reset()
    onset: float | None = None
    while clock.getTime() < seconds:
        stimulus.draw()
        for extra in extra_stimuli:
            extra.draw()
        flip_time = win.flip()
        if onset is None:
            onset = flip_time
        if keyboard.getKeys(keyList=["escape"], waitRelease=False):
            raise TaskAborted
    assert onset is not None
    return onset


def calibration_progress_text(
    elapsed_seconds: float,
    total_seconds: float,
    running: bool,
) -> str:
    if not running:
        return "Calibration complete"
    elapsed = min(max(0.0, elapsed_seconds), total_seconds)
    remaining = max(0.0, total_seconds - elapsed)
    if remaining == 0:
        return "Calibrating… finalizing clean EEG windows"
    return (
        f"Calibrating… {elapsed:.0f}/{total_seconds:.0f} s "
        f"({remaining:.0f} s remaining)"
    )


def _run_calibration(
    *,
    win: Any,
    keyboard: Any,
    engine: LoopEngine,
    fixation: Any,
    eeg_panel: _PsychoPyEegPanel | None,
    calibration_stim: Any,
    clock: Any,
    seconds: float,
    minimum_display_seconds: float = 2.0,
) -> None:
    errors: list[Exception] = []

    def calibrate() -> None:
        try:
            engine.calibrate(seconds=seconds)
        except Exception as exc:
            errors.append(exc)

    thread = threading.Thread(
        target=calibrate,
        name="flanker-calibration",
        daemon=True,
    )
    keyboard.clearEvents()
    clock.reset()
    thread.start()
    while thread.is_alive() or clock.getTime() < minimum_display_seconds:
        elapsed = clock.getTime()
        calibration_stim.text = calibration_progress_text(
            elapsed,
            seconds,
            thread.is_alive(),
        )
        fixation.draw()
        if eeg_panel is not None:
            eeg_panel.set_feedback(None)
            eeg_panel.draw()
        calibration_stim.draw()
        win.flip()
        if keyboard.getKeys(keyList=["escape"], waitRelease=False):
            engine.stop()
            thread.join(timeout=3.0)
            raise TaskAborted
    thread.join()
    if errors:
        raise errors[0]


def _verify_frame_timing(win: Any) -> tuple[float, int]:
    frame_rate = win.getActualFrameRate(
        nIdentical=20,
        nMaxFrames=180,
        nWarmUpFrames=20,
        threshold=1,
    )
    if frame_rate is None or frame_rate <= 0:
        raise RuntimeError("PsychoPy could not measure a stable display refresh rate")
    stimulus_frames = max(1, round(STIMULUS_SECONDS * frame_rate))
    actual_duration = stimulus_frames / frame_rate
    if abs(actual_duration - STIMULUS_SECONDS) > 0.004:
        raise RuntimeError(
            f"Display cannot represent a 16 ms stimulus closely enough "
            f"({frame_rate:.2f} Hz gives {actual_duration * 1000:.2f} ms)"
        )
    return frame_rate, stimulus_frames


class _PsychoPyEegPanel:
    """Compact chart drawn outside the timing-critical stimulus frame."""

    COLORS = ("#38bdf8", "#a78bfa", "#34d399", "#fbbf24")

    def __init__(
        self,
        visual: Any,
        win: Any,
        client: EegPanelClient,
        feedback_heading: str,
    ) -> None:
        self._client = client
        self._feedback_heading = feedback_heading
        self._background = visual.Rect(
            win,
            width=1.1,
            height=0.25,
            pos=(-0.18, -0.36),
            fillColor="#0b1726",
            lineColor="#334155",
        )
        self._title = visual.TextStim(
            win,
            text="EEG signal viewer",
            pos=(-0.69, -0.255),
            height=0.025,
            color="#bae6fd",
            anchorHoriz="left",
        )
        self._status = visual.TextStim(
            win,
            pos=(-0.18, -0.36),
            height=0.025,
            color="#94a3b8",
            wrapWidth=0.8,
        )
        self._feedback = visual.TextStim(
            win,
            pos=(0.53, -0.35),
            height=0.04,
            color="white",
            wrapWidth=0.32,
        )
        self._feedback.text = ""
        self._traces = [
            visual.ShapeStim(
                win,
                vertices=[(-0.62, -0.3), (0.28, -0.3)],
                closeShape=False,
                lineColor=color,
                lineWidth=1,
            )
            for color in self.COLORS
        ]
        self._labels = [
            visual.TextStim(
                win,
                pos=(-0.69, -0.3 - index * 0.047),
                height=0.019,
                color=self.COLORS[index],
                anchorHoriz="left",
            )
            for index in range(len(self.COLORS))
        ]

    def set_feedback(
        self,
        feedback: tuple[str, str] | None,
        classification_source: str | None = None,
    ) -> None:
        if feedback is None:
            self._feedback.text = ""
            return
        cognitive_load, guidance = feedback
        heading = self._feedback_heading
        if classification_source == "recorded_replay":
            heading = "Experimental replay risk (NOT LIVE)"
        self._feedback.text = (
            f"{heading}\n"
            f"{guidance}"
        )
        self._feedback.color = (
            "#f87171" if cognitive_load == "high" else "#4ade80"
        )

    def draw(self) -> None:
        snapshot = self._client.snapshot()
        if snapshot.is_replay_fallback:
            self._title.text = "EEG — FLIP-CUP REPLAY (NOT LIVE)"
            self._title.color = "#fbbf24"
        elif snapshot.source in {"live_unicorn", "live_ant"}:
            self._title.text = "EEG — LIVE"
            self._title.color = "#86efac"
        else:
            self._title.text = "EEG signal viewer"
            self._title.color = "#bae6fd"
        self._background.draw()
        self._title.draw()
        if self._feedback.text:
            self._feedback.draw()
        if (
            snapshot.status != "streaming"
            or not snapshot.times_s
            or not snapshot.values_uv
        ):
            self._status.text = (
                snapshot.error
                or snapshot.notice
                or f"EEG: {snapshot.status}"
            )
            self._status.draw()
            return

        count = min(
            len(snapshot.channel_names),
            len(snapshot.values_uv),
            len(self._traces),
        )
        sample_step = max(1, len(snapshot.times_s) // 140)
        times = snapshot.times_s[::sample_step]
        if len(times) < 2 or times[-1] <= times[0]:
            self._status.text = "EEG: waiting for samples"
            self._status.draw()
            return
        x_start, x_end = -0.62, 0.28
        for index in range(count):
            values = snapshot.values_uv[index][::sample_step]
            mean = sum(values) / len(values)
            centered = [value - mean for value in values]
            scale = max(max(abs(value) for value in centered), 1e-9)
            row_y = -0.3 - index * 0.047
            vertices = [
                (
                    x_start
                    + (time - times[0]) / (times[-1] - times[0])
                    * (x_end - x_start),
                    row_y + value / scale * 0.016,
                )
                for time, value in zip(times, centered)
            ]
            self._traces[index].vertices = vertices
            self._traces[index].draw()
            self._labels[index].text = snapshot.channel_names[index]
            self._labels[index].draw()


def _run_trial(
    *,
    win: Any,
    keyboard: Any,
    engine: LoopEngine,
    trial: Trial,
    trial_index: int,
    block_index: int,
    feedback_enabled: bool,
    participant: str,
    engine_mode: str,
    model_id: str,
    rng: random.Random,
    text_stim: Any,
    fixation: Any,
    eeg_panel: _PsychoPyEegPanel | None,
    response_clock: Any,
    display_clock: Any,
    stimulus_frames: int,
) -> dict[str, object]:
    panel = (eeg_panel,) if feedback_enabled and eeg_panel is not None else ()
    if eeg_panel is not None:
        eeg_panel.set_feedback(None)
    _show_for(
        win,
        keyboard,
        fixation,
        ISI_SECONDS,
        display_clock,
        panel,
    )

    state = engine.state()
    reset_cue_shown = should_show_intervention(state, feedback_enabled)
    load_feedback = cognitive_load_feedback(state, feedback_enabled)
    cognitive_load, guidance = load_feedback or (None, None)
    if eeg_panel is not None:
        eeg_panel.set_feedback(load_feedback, state.source)
    if reset_cue_shown:
        _wait_for_continue(
            win,
            keyboard,
            text_stim,
            "Pause and reset\nTake a moment to settle before the next trial.",
            panel,
        )
        _show_for(
            win,
            keyboard,
            fixation,
            ISI_SECONDS,
            display_clock,
            panel,
        )

    response_window = rng.uniform(*RESPONSE_WINDOW_RANGE)
    text_stim.text = trial.pattern
    keyboard.clearEvents()
    win.callOnFlip(response_clock.reset)
    win.callOnFlip(keyboard.clock.reset)
    win.callOnFlip(
        engine.mark,
        stimulus_code(trial),
        f"stimulus_{trial.congruency}",
    )

    onset: float | None = None
    response: str | None = None
    response_time: float | None = None
    for _ in range(stimulus_frames):
        text_stim.draw()
        flip_time = win.flip()
        if onset is None:
            onset = flip_time
        keys = keyboard.getKeys(
            keyList=["left", "right", "escape"], waitRelease=False, clear=True
        )
        if any(key.name == "escape" for key in keys):
            raise TaskAborted
        answer = next((key for key in keys if key.name in {"left", "right"}), None)
        if answer is not None and response is None:
            response, response_time = answer.name, float(answer.rt)
            answer_correct = response == trial.correct_key
            engine.mark(
                response_code(trial, answer_correct),
                f"response_{'correct' if answer_correct else 'incorrect'}",
            )

    fixation.draw()
    for extra in panel:
        extra.draw()
    offset = win.flip()
    while response_clock.getTime() < response_window:
        fixation.draw()
        for extra in panel:
            extra.draw()
        win.flip()
        keys = keyboard.getKeys(
            keyList=["left", "right", "escape"], waitRelease=False, clear=True
        )
        if any(key.name == "escape" for key in keys):
            raise TaskAborted
        answer = next((key for key in keys if key.name in {"left", "right"}), None)
        if answer is not None and response is None:
            response, response_time = answer.name, float(answer.rt)
            answer_correct = response == trial.correct_key
            engine.mark(
                response_code(trial, answer_correct),
                f"response_{'correct' if answer_correct else 'incorrect'}",
            )

    correct: bool | None = None if response is None else response == trial.correct_key

    text_stim.text = "Too slow" if correct is None else ("Correct" if correct else "Incorrect")
    win.callOnFlip(
        engine.mark,
        feedback_code(trial, correct),
        "feedback_missed" if correct is None else f"feedback_{'correct' if correct else 'incorrect'}",
    )
    feedback_onset = _show_for(
        win,
        keyboard,
        text_stim,
        FEEDBACK_SECONDS,
        display_clock,
        panel,
    )

    assert onset is not None
    return {
        "participant": participant,
        "engine_mode": engine_mode,
        "model_id": model_id,
        "classification_source": state.source,
        "block_index": block_index,
        "feedback_enabled": feedback_enabled,
        "trial_index": trial_index,
        "congruency": trial.congruency,
        "stimulus_pattern": trial.pattern,
        "correct_key": trial.correct_key,
        "response": response,
        "stimulus_onset": onset,
        "stimulus_offset": offset,
        "response_time": response_time,
        "response_window_seconds": response_window,
        "correct": correct,
        "lapse_probability": state.lapse_probability,
        "intervene": state.intervene,
        "status": state.status,
        "cognitive_load": cognitive_load,
        "guidance": guidance,
        "reset_cue_shown": reset_cue_shown,
        "feedback_onset": feedback_onset,
    }


def run_experiment(
    *,
    participant: str,
    engine: LoopEngine,
    seed: int,
    first_condition: str,
    output_dir: Path,
    eeg_websocket_url: str | None = None,
    eeg_fallback_websocket_url: str | None = None,
    trials_per_block: int = 120,
    condition_sequence: tuple[bool, ...] | None = None,
    engine_mode: str = "mock",
    model_id: str = "",
    feedback_heading: str = "Mental state feedback (simulation)",
    calibration_seconds: float = CALIBRATION_SECONDS,
) -> Path:
    """Run calibration plus control/intervention blocks and return the CSV path."""
    from psychopy import core, visual
    from psychopy.hardware.keyboard import Keyboard

    participant = _safe_participant_id(participant)
    build_trials(seed, trials_per_block)
    if calibration_seconds <= 0:
        raise ValueError("Calibration duration must be positive")
    conditions = (
        condition_sequence
        if condition_sequence is not None
        else ((False, True) if first_condition == "control" else (True, False))
    )
    if not conditions:
        raise ValueError("At least one task block is required")
    output_dir.mkdir(parents=True, exist_ok=True)
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    output_path = output_dir / f"{participant}_flanker_{timestamp}.csv"

    win = visual.Window(
        fullscr=True,
        allowGUI=False,
        color="#111827",
        units="height",
        waitBlanking=True,
    )
    keyboard = Keyboard()
    text_stim = visual.TextStim(win, color="white", height=0.09, wrapWidth=1.5)
    fixation = visual.TextStim(win, text="+", color="white", height=0.08)
    calibration_stim = visual.TextStim(
        win,
        text="Calibrating…",
        pos=(0.73, 0.46),
        height=0.03,
        color="#fbbf24",
        anchorHoriz="right",
    )
    eeg_client = (
        EegPanelClient(
            eeg_websocket_url,
            fallback_websocket_url=eeg_fallback_websocket_url,
        )
        if eeg_websocket_url is not None
        else None
    )
    eeg_panel = (
        _PsychoPyEegPanel(
            visual,
            win,
            eeg_client,
            feedback_heading,
        )
        if eeg_client is not None
        else None
    )
    response_clock = core.Clock()
    display_clock = core.Clock()

    engine_started = False
    try:
        if eeg_client is not None:
            eeg_client.start()
        frame_rate, stimulus_frames = _verify_frame_timing(win)
        win.recordFrameIntervals = True
        _wait_for_continue(
            win,
            keyboard,
            text_stim,
            "Respond to the CENTER arrow.\nLEFT arrow: left key\nRIGHT arrow: right key",
        )

        engine.start()
        engine_started = True
        _run_calibration(
            win=win,
            keyboard=keyboard,
            engine=engine,
            fixation=fixation,
            eeg_panel=eeg_panel,
            calibration_stim=calibration_stim,
            clock=display_clock,
            seconds=calibration_seconds,
        )
        engine_error = getattr(engine, "last_error", None)
        if engine_error:
            panel = (eeg_panel,) if eeg_panel is not None else ()
            _wait_for_continue(
                win,
                keyboard,
                text_stim,
                "Live classifier unavailable; interventions are disabled.\n"
                f"{engine_error}",
                panel,
            )

        with output_path.open("w", newline="", encoding="utf-8") as handle:
            writer = csv.DictWriter(handle, fieldnames=CSV_FIELDS)
            writer.writeheader()
            for block_index, feedback_enabled in enumerate(conditions, start=1):
                condition_name = "intervention enabled" if feedback_enabled else "control"
                _wait_for_continue(
                    win,
                    keyboard,
                    text_stim,
                    f"Block {block_index} of {len(conditions)}\n"
                    f"Feedback: {condition_name}",
                )
                trials = build_trials(seed + block_index, trials_per_block)
                rng = random.Random(seed + 10_000 + block_index)
                for trial_index, trial in enumerate(trials, start=1):
                    row = _run_trial(
                        win=win,
                        keyboard=keyboard,
                        engine=engine,
                        trial=trial,
                        trial_index=trial_index,
                        block_index=block_index,
                        feedback_enabled=feedback_enabled,
                        participant=participant,
                        engine_mode=engine_mode,
                        model_id=model_id,
                        rng=rng,
                        text_stim=text_stim,
                        fixation=fixation,
                        eeg_panel=eeg_panel,
                        response_clock=response_clock,
                        display_clock=display_clock,
                        stimulus_frames=stimulus_frames,
                    )
                    writer.writerow(row)
                    handle.flush()

        dropped_frames = sum(
            interval > (1.5 / frame_rate) for interval in win.frameIntervals
        )
        _wait_for_continue(
            win,
            keyboard,
            text_stim,
            f"Experiment complete.\nDropped/late frames: {dropped_frames}",
        )
        return output_path
    except TaskAborted:
        return output_path
    finally:
        if engine_started:
            engine.stop()
        if eeg_client is not None:
            eeg_client.stop()
        win.close()
