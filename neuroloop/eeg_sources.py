"""Interchangeable recorded and live EEG sources for the waveform server."""
from __future__ import annotations

import asyncio
import contextlib
from dataclasses import dataclass
import math
from pathlib import Path
import sys
from typing import AsyncIterator, Protocol

import mne
from pylsl import StreamInlet, resolve_byprop

from .features import FRONTAL_MIDLINE, POSTERIOR


UNICORN_SAMPLE_RATE_HZ = 250.0
UNICORN_EEG_CHANNELS = ("Fz", "C3", "Cz", "C4", "Pz", "PO7", "Oz", "PO8")


@dataclass(frozen=True)
class EegMetadata:
    source: str
    channel_names: tuple[str, ...]
    sample_rate_hz: float
    duration_seconds: float | None
    timestamp_origin_s: float | None


@dataclass(frozen=True)
class EegChunk:
    sequence: int
    timestamps_s: tuple[float, ...]
    values_uv: tuple[tuple[float, ...], ...]


class EegSource(Protocol):
    metadata: EegMetadata

    async def chunks(self) -> AsyncIterator[EegChunk]:
        """Yield channel-major microvolt chunks with source-relative timestamps."""
        ...

    def close(self) -> None:
        """Release the recording or live inlet."""
        ...


def _select_recording_channels(
    raw: mne.io.BaseRaw, requested: list[str] | None
) -> list[int]:
    by_upper = {name.upper(): index for index, name in enumerate(raw.ch_names)}
    if requested:
        missing = [name for name in requested if name.upper() not in by_upper]
        if missing:
            raise ValueError(
                f"Recording is missing requested channels: {', '.join(missing)}"
            )
        return [by_upper[name.upper()] for name in requested]

    feature_names = {
        *(name.upper() for name in FRONTAL_MIDLINE),
        *(name.upper() for name in POSTERIOR),
    }
    picks = [
        index
        for index, name in enumerate(raw.ch_names)
        if name.upper() in feature_names or name.upper().startswith("EOG")
    ]
    picked_names = [raw.ch_names[index].upper() for index in picks]
    if not any(
        name in {candidate.upper() for candidate in FRONTAL_MIDLINE}
        for name in picked_names
    ):
        raise ValueError("Recording has no frontal-midline feature channel")
    if not any(
        name in {candidate.upper() for candidate in POSTERIOR}
        for name in picked_names
    ):
        raise ValueError("Recording has no posterior feature channel")
    return picks[:8]


class RecordedReplaySource:
    """Replay selected channels from an ANT recording at recording speed."""

    def __init__(
        self,
        path: Path,
        *,
        duration_seconds: float,
        chunk_seconds: float,
        speed: float,
        channels: list[str] | None = None,
    ) -> None:
        if not path.is_file():
            raise FileNotFoundError(f"Recording does not exist: {path}")
        if duration_seconds <= 0 or chunk_seconds <= 0 or speed <= 0:
            raise ValueError("Replay duration, chunk size, and speed must be positive")
        with contextlib.redirect_stdout(sys.stderr):
            self._raw = mne.io.read_raw_ant(str(path), preload=False, verbose=False)
        try:
            self._picks = _select_recording_channels(self._raw, channels)
        except Exception:
            self._raw.close()
            raise

        self._sample_rate = float(self._raw.info["sfreq"])
        self._stop_sample = min(
            self._raw.n_times, round(duration_seconds * self._sample_rate)
        )
        self._chunk_samples = max(1, round(chunk_seconds * self._sample_rate))
        self._speed = speed
        self.metadata = EegMetadata(
            source="recorded_replay",
            channel_names=tuple(self._raw.ch_names[index] for index in self._picks),
            sample_rate_hz=self._sample_rate,
            duration_seconds=self._stop_sample / self._sample_rate,
            timestamp_origin_s=0.0,
        )

    async def chunks(self) -> AsyncIterator[EegChunk]:
        loop = asyncio.get_running_loop()
        started = loop.time()
        for sequence, start in enumerate(
            range(0, self._stop_sample, self._chunk_samples)
        ):
            stop = min(start + self._chunk_samples, self._stop_sample)
            target_time = started + (stop / self._sample_rate) / self._speed
            await asyncio.sleep(max(0.0, target_time - loop.time()))
            values = await asyncio.to_thread(
                self._raw.get_data, self._picks, start, stop
            )
            values_uv = values * 1e6
            timestamps = tuple(
                sample / self._sample_rate for sample in range(start, stop)
            )
            yield EegChunk(
                sequence=sequence,
                timestamps_s=timestamps,
                values_uv=tuple(tuple(channel) for channel in values_uv.tolist()),
            )

    def close(self) -> None:
        self._raw.close()


class UnicornLslSource:
    """Receive the official Unicorn LSL stream from Unicorn Suite."""

    def __init__(
        self,
        stream_name: str,
        *,
        resolve_timeout: float,
        chunk_seconds: float,
        idle_timeout: float = 2.0,
    ) -> None:
        if not stream_name.strip():
            raise ValueError("Unicorn LSL stream name cannot be empty")
        if resolve_timeout <= 0 or chunk_seconds <= 0 or idle_timeout <= 0:
            raise ValueError("LSL timeouts and chunk size must be positive")

        streams = resolve_byprop(
            "name", stream_name, minimum=1, timeout=resolve_timeout
        )
        if not streams:
            raise ConnectionError(
                f"No LSL stream named {stream_name!r}. "
                "Open and start UnicornLSL in Unicorn Suite."
            )
        if len(streams) != 1:
            raise ConnectionError(
                f"Found {len(streams)} LSL streams named {stream_name!r}; "
                "give each stream a unique name."
            )

        info = streams[0]
        sample_rate = float(info.nominal_srate())
        if not math.isclose(
            sample_rate, UNICORN_SAMPLE_RATE_HZ, rel_tol=0.0, abs_tol=0.01
        ):
            raise ValueError(
                f"Stream {stream_name!r} reports {sample_rate:g} Hz; "
                f"expected a Unicorn stream at {UNICORN_SAMPLE_RATE_HZ:g} Hz"
            )
        if info.channel_count() < len(UNICORN_EEG_CHANNELS):
            raise ValueError(
                f"Stream {stream_name!r} has {info.channel_count()} channels; "
                f"expected at least {len(UNICORN_EEG_CHANNELS)}"
            )

        self._inlet = StreamInlet(
            info,
            max_buflen=5,
            max_chunklen=max(1, round(chunk_seconds * sample_rate)),
        )
        self._inlet.open_stream(timeout=resolve_timeout)
        self._sample_rate = sample_rate
        self._chunk_samples = max(1, round(chunk_seconds * sample_rate))
        self._idle_timeout = idle_timeout
        self.metadata = EegMetadata(
            source="live_unicorn",
            channel_names=UNICORN_EEG_CHANNELS,
            sample_rate_hz=sample_rate,
            duration_seconds=None,
            timestamp_origin_s=None,
        )

    async def chunks(self) -> AsyncIterator[EegChunk]:
        loop = asyncio.get_running_loop()
        last_data_at = loop.time()
        sequence = 0
        while True:
            samples, timestamps = await asyncio.to_thread(
                self._inlet.pull_chunk,
                0.25,
                self._chunk_samples,
            )
            if not samples:
                if loop.time() - last_data_at >= self._idle_timeout:
                    raise ConnectionError(
                        "Unicorn LSL stream stopped delivering samples"
                    )
                continue
            last_data_at = loop.time()
            if len(samples) != len(timestamps):
                raise ValueError("Unicorn LSL samples and timestamps differ in length")
            if any(len(sample) < len(UNICORN_EEG_CHANNELS) for sample in samples):
                raise ValueError("Unicorn LSL sample has fewer than eight EEG values")
            selected_samples = [
                [float(value) for value in sample[: len(UNICORN_EEG_CHANNELS)]]
                for sample in samples
            ]
            if not all(
                math.isfinite(value)
                for sample in selected_samples
                for value in sample
            ):
                raise ValueError("Unicorn LSL stream contains a non-finite EEG value")
            source_timestamps = tuple(float(timestamp) for timestamp in timestamps)
            values_uv = tuple(
                tuple(sample[channel] for sample in selected_samples)
                for channel in range(len(UNICORN_EEG_CHANNELS))
            )
            yield EegChunk(
                sequence=sequence,
                timestamps_s=source_timestamps,
                values_uv=values_uv,
            )
            sequence += 1

    def close(self) -> None:
        self._inlet.close_stream()
