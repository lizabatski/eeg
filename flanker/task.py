"""COG-BCI-compatible Eriksen flanker task driven by a LoopEngine."""
from __future__ import annotations

import csv
from dataclasses import dataclass
from datetime import datetime
from pathlib import Path
import random
import re
from typing import TYPE_CHECKING, Any, Iterable

if TYPE_CHECKING:
    from neuroloop.loop import LoopEngine, LoopState


TRIALS_PER_PATTERN = 30
CALIBRATION_SECONDS = 120.0
ISI_SECONDS = 2.0
STIMULUS_SECONDS = 0.016
RESPONSE_WINDOW_RANGE = (2.25, 2.75)
FEEDBACK_SECONDS = 0.5
RESET_CUE_SECONDS = 1.5


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


def build_trials(seed: int) -> list[Trial]:
    """Return 120 balanced trials with no long condition or response runs."""
    trials = [trial for trial in PATTERNS for _ in range(TRIALS_PER_PATTERN)]
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


def _wait_for_continue(win: Any, keyboard: Any, text_stim: Any, message: str) -> None:
    text_stim.text = f"{message}\n\nPress SPACE to continue."
    keyboard.clearEvents()
    while True:
        text_stim.draw()
        win.flip()
        keys = keyboard.getKeys(keyList=["space", "escape"], waitRelease=False)
        if any(key.name == "escape" for key in keys):
            raise TaskAborted
        if any(key.name == "space" for key in keys):
            return


def _show_for(win: Any, keyboard: Any, stimulus: Any, seconds: float, clock: Any) -> float:
    clock.reset()
    onset: float | None = None
    while clock.getTime() < seconds:
        stimulus.draw()
        flip_time = win.flip()
        if onset is None:
            onset = flip_time
        if keyboard.getKeys(keyList=["escape"], waitRelease=False):
            raise TaskAborted
    assert onset is not None
    return onset


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
    rng: random.Random,
    text_stim: Any,
    fixation: Any,
    response_clock: Any,
    display_clock: Any,
    stimulus_frames: int,
) -> dict[str, object]:
    _show_for(win, keyboard, fixation, ISI_SECONDS, display_clock)

    state = engine.state()
    reset_cue_shown = should_show_intervention(state, feedback_enabled)
    if reset_cue_shown:
        text_stim.text = "Pause and reset"
        _show_for(win, keyboard, text_stim, RESET_CUE_SECONDS, display_clock)

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
    offset = win.flip()
    while response_clock.getTime() < response_window:
        fixation.draw()
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
        win, keyboard, text_stim, FEEDBACK_SECONDS, display_clock
    )

    assert onset is not None
    return {
        "participant": participant,
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
) -> Path:
    """Run calibration plus control/intervention blocks and return the CSV path."""
    from psychopy import core, visual
    from psychopy.hardware.keyboard import Keyboard

    participant = _safe_participant_id(participant)
    conditions = (
        (False, True) if first_condition == "control" else (True, False)
    )
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
    response_clock = core.Clock()
    display_clock = core.Clock()

    engine_started = False
    try:
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
        text_stim.text = "Calibration\nPlease remain still and focus on the cross."
        text_stim.draw()
        win.flip()
        engine.calibrate(seconds=CALIBRATION_SECONDS)

        with output_path.open("w", newline="", encoding="utf-8") as handle:
            writer = csv.DictWriter(handle, fieldnames=CSV_FIELDS)
            writer.writeheader()
            for block_index, feedback_enabled in enumerate(conditions, start=1):
                condition_name = "intervention enabled" if feedback_enabled else "control"
                _wait_for_continue(
                    win,
                    keyboard,
                    text_stim,
                    f"Block {block_index} of 2\nFeedback: {condition_name}",
                )
                trials = build_trials(seed + block_index)
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
                        rng=rng,
                        text_stim=text_stim,
                        fixation=fixation,
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
        win.close()
