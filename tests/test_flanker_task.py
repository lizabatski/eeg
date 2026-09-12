from collections import Counter
import unittest

from flanker.task import (
    CSV_FIELDS,
    PATTERNS,
    _verify_frame_timing,
    build_trials,
    feedback_code,
    response_code,
    should_show_intervention,
    stimulus_code,
)
from neuroloop.loop import LoopState, MockEngine


class _MeasuredWindow:
    def __init__(self, frame_rate):
        self.frame_rate = frame_rate

    def getActualFrameRate(self, **_kwargs):
        return self.frame_rate


def _states(engine, count=100):
    engine.start()
    engine.calibrate(120)
    try:
        return [engine.state() for _ in range(count)]
    finally:
        engine.stop()


class FlankerTaskTests(unittest.TestCase):
    def test_trial_order_is_balanced_and_pseudorandom(self):
        trials = build_trials(seed=7)
        self.assertEqual(len(trials), 120)
        self.assertEqual(
            Counter(trial.pattern for trial in trials),
            {"<<<<<": 30, ">>>>>": 30, "<<><<": 30, ">><>>": 30},
        )
        self.assertEqual(
            Counter(trial.congruency for trial in trials),
            {"congruent": 60, "incongruent": 60},
        )

    def test_non_ok_state_never_shows_intervention(self):
        for status in ("stale", "uncalibrated"):
            with self.subTest(status=status):
                state = LoopState(0.9, True, status, 1)
                self.assertFalse(
                    should_show_intervention(state, feedback_enabled=True)
                )

    def test_control_condition_never_shows_reset_cue(self):
        for status in ("ok", "stale", "uncalibrated"):
            for intervene in (False, True):
                with self.subTest(status=status, intervene=intervene):
                    state = LoopState(0.9, intervene, status, 1)
                    self.assertFalse(
                        should_show_intervention(state, feedback_enabled=False)
                    )

    def test_csv_contains_contract_and_timing_fields(self):
        required = {
            "trial_index",
            "congruency",
            "stimulus_onset",
            "response_time",
            "correct",
            "lapse_probability",
            "intervene",
            "status",
            "stimulus_offset",
            "feedback_onset",
        }
        self.assertLessEqual(required, set(CSV_FIELDS))

    def test_cogbci_event_codes_cover_each_pattern(self):
        congruent, _, incongruent, _ = PATTERNS
        self.assertEqual(stimulus_code(congruent), 241)
        self.assertEqual(stimulus_code(incongruent), 242)
        self.assertEqual(response_code(congruent, True), 2511)
        self.assertEqual(response_code(incongruent, False), 2522)
        self.assertEqual(feedback_code(congruent, None), 25321)
        self.assertEqual(feedback_code(incongruent, True), 25122)

    def test_frame_timing_uses_measured_refresh_rate(self):
        for frame_rate, frames in ((60.0, 1), (120.0, 2)):
            with self.subTest(frame_rate=frame_rate):
                measured, stimulus_frames = _verify_frame_timing(
                    _MeasuredWindow(frame_rate)
                )
                self.assertEqual(measured, frame_rate)
                self.assertEqual(stimulus_frames, frames)

    def test_frame_timing_fails_without_stable_measurement(self):
        with self.assertRaisesRegex(RuntimeError, "stable display refresh rate"):
            _verify_frame_timing(_MeasuredWindow(None))

    def test_mock_engine_seed_is_reproducible(self):
        first = _states(MockEngine(seed=0))
        second = _states(MockEngine(seed=0))
        self.assertEqual(first, second)

    def test_mock_engine_threshold_and_stale_configurations(self):
        frequent = _states(MockEngine(seed=0, threshold=0.3))
        rare = _states(MockEngine(seed=0, threshold=0.95))
        stale = _states(MockEngine(seed=0, stale_rate=0.5))
        self.assertTrue(any(state.intervene for state in frequent if state.usable))
        self.assertFalse(any(state.intervene for state in rare))
        self.assertEqual({state.status for state in stale}, {"ok", "stale"})


if __name__ == "__main__":
    unittest.main()
