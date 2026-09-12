import asyncio
import math
from pathlib import Path
import unittest

from neuroloop.eeg_sources import RecordedReplaySource, UnicornLslSource


ROOT = Path(__file__).resolve().parents[1]
RECORDING = (
    ROOT
    / "EEG_flipcup"
    / "Ewing_Patrick_2026-08-10_13-07-25_session-01.cnt"
)


class EegSourceTests(unittest.TestCase):
    def test_recorded_source_emits_timestamps_and_microvolt_channels(self):
        source = RecordedReplaySource(
            RECORDING,
            duration_seconds=0.1,
            chunk_seconds=0.05,
            speed=100,
        )

        async def first_chunk():
            iterator = source.chunks()
            try:
                return await anext(iterator)
            finally:
                await iterator.aclose()

        try:
            chunk = asyncio.run(first_chunk())
            self.assertEqual(source.metadata.source, "recorded_replay")
            self.assertEqual(len(source.metadata.channel_names), 8)
            self.assertEqual(len(chunk.values_uv), 8)
            self.assertEqual(len(chunk.timestamps_s), len(chunk.values_uv[0]))
            self.assertTrue(
                all(
                    later > earlier
                    for earlier, later in zip(
                        chunk.timestamps_s, chunk.timestamps_s[1:]
                    )
                )
            )
            self.assertTrue(
                all(math.isfinite(value) for channel in chunk.values_uv for value in channel)
            )
        finally:
            source.close()

    def test_recorded_source_rejects_missing_file(self):
        with self.assertRaisesRegex(FileNotFoundError, "does not exist"):
            RecordedReplaySource(
                ROOT / "missing.cnt",
                duration_seconds=1,
                chunk_seconds=0.05,
                speed=1,
            )

    def test_unicorn_source_reports_missing_lsl_stream(self):
        with self.assertRaisesRegex(ConnectionError, "No LSL stream"):
            UnicornLslSource(
                "NeuroLoop-test-stream-that-does-not-exist",
                resolve_timeout=0.1,
                chunk_seconds=0.05,
            )


if __name__ == "__main__":
    unittest.main()
