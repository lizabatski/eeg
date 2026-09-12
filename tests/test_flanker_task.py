import asyncio
from collections import Counter
import unittest

from flanker.eeg_panel import EegPanelClient, eeg_websocket_url
from flanker.task import (
    CSV_FIELDS,
    PATTERNS,
    _wait_for_continue,
    _verify_frame_timing,
    build_trials,
    calibration_progress_text,
    cognitive_load_feedback,
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


class _Drawable:
    def __init__(self):
        self.draw_count = 0
        self.text = ""

    def draw(self):
        self.draw_count += 1


class _ContinueKeyboard:
    def __init__(self):
        self.poll_count = 0

    def clearEvents(self):
        return None

    def getKeys(self, **_kwargs):
        self.poll_count += 1
        if self.poll_count < 3:
            return []
        return [type("Key", (), {"name": "space"})()]


class _FlipWindow:
    def __init__(self):
        self.flip_count = 0

    def flip(self):
        self.flip_count += 1


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

    def test_demo_has_30_balanced_trials(self):
        trials = build_trials(seed=7, trial_count=30)
        self.assertEqual(len(trials), 30)
        self.assertEqual(
            Counter(trial.congruency for trial in trials),
            {"congruent": 15, "incongruent": 15},
        )
        self.assertEqual(
            Counter(trial.correct_key for trial in trials),
            {"left": 15, "right": 15},
        )
        self.assertEqual(
            sorted(Counter(trial.pattern for trial in trials).values()),
            [7, 7, 8, 8],
        )

    def test_demo_rejects_an_unbalanced_trial_count(self):
        with self.assertRaisesRegex(ValueError, "even number"):
            build_trials(seed=7, trial_count=29)

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
                    self.assertIsNone(
                        cognitive_load_feedback(state, feedback_enabled=False)
                    )

    def test_reset_waits_for_space_and_keeps_panel_visible(self):
        window = _FlipWindow()
        keyboard = _ContinueKeyboard()
        message = _Drawable()
        panel = _Drawable()
        _wait_for_continue(
            window,
            keyboard,
            message,
            "Pause and reset",
            (panel,),
        )
        self.assertEqual(keyboard.poll_count, 3)
        self.assertEqual(window.flip_count, 3)
        self.assertEqual(message.draw_count, 3)
        self.assertEqual(panel.draw_count, 3)
        self.assertIn("Press SPACE to continue", message.text)

    def test_calibration_screen_reports_progress_and_finalization(self):
        self.assertEqual(
            calibration_progress_text(15.0, 60.0, True),
            "Calibrating… 15/60 s (45 s remaining)",
        )
        self.assertEqual(
            calibration_progress_text(60.0, 60.0, True),
            "Calibrating… finalizing clean EEG windows",
        )
        self.assertEqual(
            calibration_progress_text(60.0, 60.0, False),
            "Calibration complete",
        )

    def test_fresh_binary_load_result_maps_to_requested_guidance(self):
        low = LoopState(0.2, False, "ok", 1)
        high = LoopState(0.8, True, "ok", 2)
        self.assertEqual(
            cognitive_load_feedback(low, feedback_enabled=True),
            ("low", "Proceed"),
        )
        self.assertEqual(
            cognitive_load_feedback(high, feedback_enabled=True),
            ("high", "Calm down"),
        )

    def test_high_risk_guidance_does_not_require_a_repeated_break(self):
        high_without_new_break = LoopState(
            0.8,
            False,
            "ok",
            3,
            risk_high=True,
        )
        self.assertEqual(
            cognitive_load_feedback(
                high_without_new_break,
                feedback_enabled=True,
            ),
            ("high", "Calm down"),
        )

    def test_stale_load_result_is_not_displayed(self):
        stale = LoopState(0.8, True, "stale", 1)
        self.assertIsNone(cognitive_load_feedback(stale, feedback_enabled=True))

    def test_eeg_panel_selects_requested_channels_and_buffers_samples(self):
        client = EegPanelClient(
            "ws://127.0.0.1:8765/?source=ant",
            requested_channels=("Fz", "Pz"),
        )
        client._handle_metadata(
            {
                "channel_names": ["Fp1", "Fz", "Pz"],
                "sample_rate_hz": 250.0,
            }
        )
        client._handle_samples(
            {
                "sequence": 0,
                "timestamps_s": [100.0, 100.004],
                "values_uv": [[1.0, 2.0], [3.0, 4.0], [5.0, 6.0]],
            }
        )
        snapshot = client.snapshot()
        self.assertEqual(snapshot.status, "streaming")
        self.assertEqual(snapshot.channel_names, ("Fz", "Pz"))
        self.assertEqual(snapshot.times_s[0], 0.0)
        self.assertAlmostEqual(snapshot.times_s[1], 0.004)
        self.assertEqual(snapshot.values_uv, ((3.0, 4.0), (5.0, 6.0)))

    def test_eeg_panel_does_not_substitute_missing_channels(self):
        client = EegPanelClient(
            "ws://127.0.0.1:8765/?source=ant",
            requested_channels=("Fz", "Pz"),
        )
        with self.assertRaisesRegex(ValueError, "none of the requested"):
            client._handle_metadata(
                {
                    "channel_names": ["A1", "A2"],
                    "sample_rate_hz": 250.0,
                }
            )

    def test_live_failure_switches_to_explicit_flipcup_replay(self):
        client = EegPanelClient(
            "ws://127.0.0.1:8765/?source=ant",
            fallback_websocket_url="ws://127.0.0.1:8765/?source=replay",
        )
        requested_urls = []

        async def receive(url, *, is_replay_fallback):
            requested_urls.append(url)
            if not is_replay_fallback:
                raise ConnectionError("ANT stream not found")
            client._handle_metadata(
                {
                    "source": "recorded_replay",
                    "channel_names": ["Fz", "Pz", "O1"],
                    "sample_rate_hz": 250.0,
                },
                is_replay_fallback=True,
            )

        client._receive = receive
        asyncio.run(client._receive_with_fallback())
        snapshot = client.snapshot()
        self.assertEqual(
            requested_urls,
            [
                "ws://127.0.0.1:8765/?source=ant",
                "ws://127.0.0.1:8765/?source=replay",
            ],
        )
        self.assertTrue(snapshot.is_replay_fallback)
        self.assertEqual(snapshot.source, "recorded_replay")
        self.assertIn("recorded flip-cup", snapshot.notice)

    def test_eeg_url_replaces_source_without_dropping_parameters(self):
        self.assertEqual(
            eeg_websocket_url(
                "ws://127.0.0.1:8765/eeg?source=replay&token=test",
                "ant",
            ),
            "ws://127.0.0.1:8765/eeg?token=test&source=ant",
        )

    def test_csv_contains_contract_and_timing_fields(self):
        required = {
            "engine_mode",
            "model_id",
            "classification_source",
            "trial_index",
            "congruency",
            "stimulus_onset",
            "response_time",
            "correct",
            "lapse_probability",
            "intervene",
            "status",
            "cognitive_load",
            "guidance",
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
