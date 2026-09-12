import asyncio
from pathlib import Path
from types import SimpleNamespace
import tempfile
import unittest

import numpy as np

from neuroloop.live_model import (
    ARTIFACT_THRESHOLD_VOLTS,
    FILTER_BAND_HZ,
    FILTER_ORDER,
    MODEL_CHANNELS,
    MODEL_FEATURES,
    MODEL_ID,
    TARGET_SAMPLE_RATE_HZ,
    WINDOW_SECONDS,
    CausalBandpass,
    DeploymentModel,
    build_pipeline,
    extract_model_vector,
    load_deployment_model,
    require_model_channels,
    save_deployment_model,
    window_is_clean,
)
from neuroloop.loop import LiveEngine


def _test_model() -> DeploymentModel:
    rng = np.random.default_rng(0)
    x = rng.normal(size=(20, len(MODEL_FEATURES)))
    y = np.array([0, 1] * 10)
    return DeploymentModel(
        model_id=MODEL_ID,
        pipeline=build_pipeline().fit(x, y),
        channels=MODEL_CHANNELS,
        feature_names=MODEL_FEATURES,
        window_seconds=WINDOW_SECONDS,
        target_sample_rate_hz=TARGET_SAMPLE_RATE_HZ,
        filter_band_hz=FILTER_BAND_HZ,
        filter_order=FILTER_ORDER,
        artifact_threshold_volts=ARTIFACT_THRESHOLD_VOLTS,
        label="flip_cup_failure",
        evaluation={"mean_auc": 0.5},
    )


class LiveModelTests(unittest.TestCase):
    def test_causal_filter_matches_chunked_processing(self):
        rng = np.random.default_rng(2)
        values = rng.normal(scale=10e-6, size=(len(MODEL_CHANNELS), 1000))
        whole = CausalBandpass(500.0, len(MODEL_CHANNELS)).process(values)
        chunk_filter = CausalBandpass(500.0, len(MODEL_CHANNELS))
        chunked = np.concatenate(
            [
                chunk_filter.process(values[:, :137]),
                chunk_filter.process(values[:, 137:611]),
                chunk_filter.process(values[:, 611:]),
            ],
            axis=1,
        )
        np.testing.assert_allclose(whole, chunked, atol=1e-15, rtol=1e-12)

    def test_model_vector_has_fixed_feature_contract(self):
        sample_rate = 500.0
        time = np.arange(round(WINDOW_SECONDS * sample_rate)) / sample_rate
        window = np.vstack(
            [
                10e-6 * np.sin(2 * np.pi * (6 + index) * time)
                for index in range(len(MODEL_CHANNELS))
            ]
        )
        vector = extract_model_vector(window, sample_rate)
        self.assertEqual(vector.shape, (len(MODEL_FEATURES),))
        self.assertTrue(np.all(np.isfinite(vector)))

    def test_model_requires_exact_live_montage(self):
        self.assertEqual(
            require_model_channels(list(reversed(MODEL_CHANNELS))),
            tuple(reversed(range(len(MODEL_CHANNELS)))),
        )
        with self.assertRaisesRegex(ValueError, "missing: O2"):
            require_model_channels(list(MODEL_CHANNELS[:-1]))

    def test_artifact_threshold_rejects_large_channel_excursion(self):
        window = np.zeros((len(MODEL_CHANNELS), 375))
        self.assertTrue(window_is_clean(window))
        window[0, 0] = ARTIFACT_THRESHOLD_VOLTS * 1.1
        self.assertFalse(window_is_clean(window))

    def test_model_artifact_round_trip_validates_contract(self):
        model = _test_model()
        with tempfile.TemporaryDirectory() as directory:
            model_path = Path(directory) / "model.joblib"
            manifest_path = Path(directory) / "model.json"
            save_deployment_model(model, model_path, manifest_path)
            loaded = load_deployment_model(model_path)
            self.assertEqual(loaded.model_id, MODEL_ID)
            self.assertTrue(manifest_path.is_file())

    def test_repository_contains_trained_deployment_artifact(self):
        artifact = (
            Path(__file__).resolve().parents[1]
            / "artifacts"
            / "flipcup_live_model.joblib"
        )
        model = load_deployment_model(artifact)
        self.assertEqual(model.model_id, MODEL_ID)
        self.assertEqual(model.evaluation["pooled_training_trials"], 100)

    def test_live_engine_consumes_one_break_and_requires_rearm_and_cooldown(self):
        now = [100.0]
        engine = LiveEngine(
            stream_name="",
            model=_test_model(),
            threshold=0.5,
            rearm_threshold=0.45,
            cooldown_seconds=10.0,
            source_factory=lambda: None,
            monotonic=lambda: now[0],
        )
        engine._calibrated = True
        engine._last_data_at = now[0]

        engine._accept_probability(0.8, now[0])
        first = engine.state()
        second = engine.state()
        self.assertTrue(first.intervene)
        self.assertTrue(first.risk_high)
        self.assertFalse(second.intervene)
        self.assertTrue(second.risk_high)

        now[0] = 102.0
        engine._last_data_at = now[0]
        engine._accept_probability(0.4, now[0])
        now[0] = 105.0
        engine._last_data_at = now[0]
        engine._accept_probability(0.8, now[0])
        self.assertFalse(engine.state().intervene)
        now[0] = 111.0
        engine._last_data_at = now[0]
        engine._accept_probability(0.8, now[0])
        self.assertTrue(engine.state().intervene)

    def test_live_engine_rejects_replay_as_intervention_input(self):
        class ReplaySource:
            metadata = SimpleNamespace(
                source="recorded_replay",
                channel_names=MODEL_CHANNELS,
                sample_rate_hz=500.0,
            )

            def close(self):
                return None

        engine = LiveEngine(
            stream_name="",
            model=_test_model(),
            source_factory=ReplaySource,
        )
        with self.assertRaisesRegex(ValueError, "replay cannot drive"):
            asyncio.run(engine._reader())

    def test_explicit_replay_source_can_drive_an_indicated_intervention(self):
        sample_rate = 500.0
        samples = round(WINDOW_SECONDS * sample_rate)
        times = np.arange(samples) / sample_rate

        class ReplaySource:
            metadata = SimpleNamespace(
                source="recorded_replay",
                channel_names=MODEL_CHANNELS,
                sample_rate_hz=sample_rate,
            )

            async def chunks(self):
                yield SimpleNamespace(
                    timestamps_s=tuple(times),
                    values_uv=tuple(
                        tuple(
                            10.0
                            * np.sin(
                                2
                                * np.pi
                                * (6 + channel_index)
                                * times
                            )
                        )
                        for channel_index in range(len(MODEL_CHANNELS))
                    ),
                )

            def close(self):
                return None

        model = _test_model()
        model.predict_failure_probability = lambda _vector: 0.8
        engine = LiveEngine(
            stream_name="",
            model=model,
            allow_replay=True,
            source_factory=ReplaySource,
            monotonic=lambda: 100.0,
        )
        engine._calibrated = True
        asyncio.run(engine._reader())
        state = engine.state()
        self.assertEqual(state.source, "recorded_replay")
        self.assertEqual(state.status, "ok")
        self.assertTrue(state.intervene)
        self.assertTrue(state.risk_high)

    def test_live_reader_calibrates_and_runs_saved_feature_pipeline(self):
        sample_rate = 500.0
        samples_per_chunk = round(WINDOW_SECONDS * sample_rate)

        class LiveSource:
            metadata = SimpleNamespace(
                source="live_ant",
                channel_names=MODEL_CHANNELS,
                sample_rate_hz=sample_rate,
            )

            async def chunks(self):
                for chunk_index in range(31):
                    start = chunk_index * WINDOW_SECONDS
                    times = start + np.arange(samples_per_chunk) / sample_rate
                    values = tuple(
                        tuple(
                            10.0
                            * np.sin(
                                2
                                * np.pi
                                * (6 + channel_index)
                                * times
                            )
                        )
                        for channel_index in range(len(MODEL_CHANNELS))
                    )
                    yield SimpleNamespace(
                        timestamps_s=tuple(times),
                        values_uv=values,
                    )

            def close(self):
                return None

        now = [0.0]

        def monotonic():
            now[0] += 1.0
            return now[0]

        engine = LiveEngine(
            stream_name="",
            model=_test_model(),
            source_factory=LiveSource,
            monotonic=monotonic,
        )
        engine._calibration_requested = True
        engine._calibration_seconds = 29.0
        asyncio.run(engine._reader())
        self.assertTrue(engine._calibrated)
        self.assertIsNone(engine.last_error)
        self.assertGreater(engine._n_windows, 0)

    def test_unavailable_live_source_calibrates_to_stale_without_breaks(self):
        engine = LiveEngine(
            stream_name="",
            model=_test_model(),
            source_factory=lambda: None,
        )
        engine._error = "ANT stream unavailable"
        engine.calibrate(120.0)
        state = engine.state()
        self.assertEqual(state.status, "stale")
        self.assertFalse(state.intervene)


if __name__ == "__main__":
    unittest.main()
