import asyncio
import math
from pathlib import Path
import unittest

from pylsl import StreamInfo

from neuroloop.eeg_sources import (
    AntLslSource,
    RecordedReplaySource,
    UnicornLslSource,
    _lsl_channel_metadata,
    _microvolt_multiplier,
    _select_ant_channels,
)


ROOT = Path(__file__).resolve().parents[1]
RECORDING = (
    ROOT
    / "EEG_flipcup"
    / "Ewing_Patrick_2026-08-10_13-07-25_session-01.cnt"
)


class EegSourceTests(unittest.TestCase):
    def test_ant_channel_metadata_preserves_labels_types_and_units(self):
        info = StreamInfo("eego", "EEG", 2, 500, "float32", "test-eego")
        channels = info.desc().append_child("channels")
        for label in ("Fz", "Pz"):
            channel = channels.append_child("channel")
            channel.append_child_value("label", label)
            channel.append_child_value("type", "EEG")
            channel.append_child_value("unit", "uV")

        parsed = _lsl_channel_metadata(info)
        self.assertEqual(tuple(channel.label for channel in parsed), ("Fz", "Pz"))
        self.assertEqual(tuple(channel.kind for channel in parsed), ("EEG", "EEG"))
        self.assertEqual(tuple(channel.unit for channel in parsed), ("uV", "uV"))

    def test_ant_units_are_converted_explicitly(self):
        self.assertEqual(_microvolt_multiplier("uV"), 1.0)
        self.assertEqual(_microvolt_multiplier("V"), 1e6)
        with self.assertRaisesRegex(ValueError, "Unsupported or missing"):
            _microvolt_multiplier("")

    def test_ant_uses_every_channel_with_voltage_units_without_type_metadata(self):
        channels = (
            _lsl_channel_metadata(
                self._stream_info(
                    ("Fp1", "", "uV"),
                    ("Fz", "", "V"),
                    ("Trigger", "", "count"),
                )
            )
        )
        picks, multipliers = _select_ant_channels(channels, requested=None)
        self.assertEqual(picks, (0, 1))
        self.assertEqual(multipliers, (1.0, 1e6))

    def test_ant_source_requires_configured_stream_name(self):
        with self.assertRaisesRegex(ValueError, "stream name is required"):
            AntLslSource("", resolve_timeout=0.1, chunk_seconds=0.05)

    @staticmethod
    def _stream_info(*descriptors):
        info = StreamInfo(
            "eego-selection", "EEG", len(descriptors), 500, "float32", "selection"
        )
        channels = info.desc().append_child("channels")
        for label, kind, unit in descriptors:
            channel = channels.append_child("channel")
            channel.append_child_value("label", label)
            channel.append_child_value("type", kind)
            channel.append_child_value("unit", unit)
        return info

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

    def test_recorded_source_can_loop_with_continuous_timestamps(self):
        source = RecordedReplaySource(
            RECORDING,
            duration_seconds=0.01,
            chunk_seconds=0.01,
            speed=100,
            loop=True,
        )

        async def two_chunks():
            iterator = source.chunks()
            try:
                return await anext(iterator), await anext(iterator)
            finally:
                await iterator.aclose()

        try:
            first, second = asyncio.run(two_chunks())
            self.assertEqual((first.sequence, second.sequence), (0, 1))
            self.assertGreater(second.timestamps_s[0], first.timestamps_s[-1])
        finally:
            source.close()

    def test_unicorn_source_reports_missing_lsl_stream(self):
        with self.assertRaisesRegex(ConnectionError, "No LSL stream"):
            UnicornLslSource(
                "NeuroLoop-test-stream-that-does-not-exist",
                resolve_timeout=0.1,
                chunk_seconds=0.05,
            )


if __name__ == "__main__":
    unittest.main()
