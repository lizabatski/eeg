"""Non-blocking EEG WebSocket client for the PsychoPy task panel.

Team: Monster's Inc

:class:`EegPanelClient` runs its WebSocket connection on a background thread
(``asyncio.run`` inside a daemon :class:`threading.Thread`) so a network
hiccup can never stall a PsychoPy stimulus frame -- the task-facing
:meth:`~EegPanelClient.snapshot` method only ever reads the latest values
under a lock and returns immediately. If the live EEG source drops,
:meth:`_receive_with_fallback` automatically reconnects to a recorded
flip-cup replay stream instead, clearly flagging the switch (``is_replay_fallback``)
so anything downstream can distinguish a live signal from a rehearsed one.
Incoming sample sequence numbers are used to detect gaps or restarts
(:meth:`_handle_samples`): a sequence moving backwards is an error, and a
sequence skipping forward clears the rolling buffer so stale pre-gap samples
are never plotted next to fresh ones.
"""
from __future__ import annotations

import asyncio
from collections import deque
from dataclasses import dataclass
import json
import math
import threading
from urllib.parse import parse_qsl, urlencode, urlsplit, urlunsplit

from websockets.asyncio.client import connect
from websockets.exceptions import ConnectionClosed


DEFAULT_PANEL_CHANNELS = ("Fz", "Pz", "O1", "O2")


def eeg_websocket_url(base_url: str, source: str) -> str:
    """Set the requested EEG source without discarding other URL parameters."""
    parsed = urlsplit(base_url)
    query = [(key, value) for key, value in parse_qsl(parsed.query) if key != "source"]
    query.append(("source", source))
    return urlunsplit(
        (parsed.scheme, parsed.netloc, parsed.path or "/", urlencode(query), "")
    )


@dataclass(frozen=True)
class EegPanelSnapshot:
    status: str
    error: str | None
    source: str | None
    is_replay_fallback: bool
    notice: str | None
    channel_names: tuple[str, ...]
    times_s: tuple[float, ...]
    values_uv: tuple[tuple[float, ...], ...]


class EegPanelClient:
    """Read EEG in a background thread without blocking PsychoPy frames."""

    def __init__(
        self,
        websocket_url: str,
        *,
        fallback_websocket_url: str | None = None,
        requested_channels: tuple[str, ...] = DEFAULT_PANEL_CHANNELS,
        window_seconds: float = 2.0,
    ) -> None:
        if not websocket_url:
            raise ValueError("EEG WebSocket URL cannot be empty")
        if not requested_channels:
            raise ValueError("At least one panel channel is required")
        if window_seconds <= 0:
            raise ValueError("EEG panel window must be positive")
        self._url = websocket_url
        self._fallback_url = fallback_websocket_url
        self._requested_channels = requested_channels
        self._window_seconds = window_seconds
        self._lock = threading.RLock()
        self._stop = threading.Event()
        self._thread: threading.Thread | None = None
        self._status = "connecting"
        self._error: str | None = None
        self._source: str | None = None
        self._is_replay_fallback = False
        self._notice: str | None = None
        self._channel_names: tuple[str, ...] = ()
        self._channel_indices: tuple[int, ...] = ()
        self._times: deque[float] = deque()
        self._values: list[deque[float]] = []
        self._timestamp_origin: float | None = None
        self._next_sequence = 0

    def start(self) -> None:
        if self._thread is not None:
            raise RuntimeError("EEG panel client is already started")
        self._thread = threading.Thread(
            target=self._thread_main,
            name="flanker-eeg-panel",
            daemon=True,
        )
        self._thread.start()

    def stop(self) -> None:
        self._stop.set()
        if self._thread is not None:
            self._thread.join(timeout=2.0)

    def snapshot(self) -> EegPanelSnapshot:
        with self._lock:
            return EegPanelSnapshot(
                status=self._status,
                error=self._error,
                source=self._source,
                is_replay_fallback=self._is_replay_fallback,
                notice=self._notice,
                channel_names=self._channel_names,
                times_s=tuple(self._times),
                values_uv=tuple(tuple(channel) for channel in self._values),
            )

    def _thread_main(self) -> None:
        try:
            asyncio.run(self._receive_with_fallback())
        except Exception as exc:
            self._set_error(str(exc))

    async def _receive_with_fallback(self) -> None:
        try:
            await self._receive(self._url, is_replay_fallback=False)
            return
        except (ConnectionError, OSError, TimeoutError) as live_error:
            if self._stop.is_set() or self._fallback_url is None:
                raise
            with self._lock:
                self._status = "connecting"
                self._error = None
                self._source = None
                self._is_replay_fallback = True
                self._notice = (
                    "Live EEG unavailable; using recorded flip-cup data"
                )
                self._channel_names = ()
                self._channel_indices = ()
                self._times.clear()
                self._values = []
            try:
                await self._receive(
                    self._fallback_url,
                    is_replay_fallback=True,
                )
            except Exception as replay_error:
                raise ConnectionError(
                    f"Live EEG failed ({live_error}); "
                    f"flip-cup replay also failed ({replay_error})"
                ) from replay_error

    async def _receive(
        self,
        websocket_url: str,
        *,
        is_replay_fallback: bool,
    ) -> None:
        async with connect(
            websocket_url,
            max_size=None,
            open_timeout=2.0,
            close_timeout=1.0,
        ) as websocket:
            while not self._stop.is_set():
                try:
                    raw = await asyncio.wait_for(websocket.recv(), timeout=0.25)
                except TimeoutError:
                    continue
                except ConnectionClosed as exc:
                    if self._stop.is_set():
                        return
                    raise ConnectionError(f"EEG WebSocket disconnected: {exc}") from exc
                if not isinstance(raw, str):
                    raise ValueError("EEG WebSocket sent a binary message")
                message = json.loads(raw)
                message_type = message.get("type")
                if message_type == "metadata":
                    self._handle_metadata(
                        message,
                        is_replay_fallback=is_replay_fallback,
                    )
                elif message_type == "samples":
                    self._handle_samples(message)
                elif message_type == "end":
                    with self._lock:
                        self._status = "finished"
                    return
                elif message_type == "error":
                    raise ConnectionError(str(message.get("message", "EEG source failed")))
                else:
                    raise ValueError(f"Unknown EEG message type: {message_type!r}")

    def _handle_metadata(
        self,
        message: dict,
        *,
        is_replay_fallback: bool = False,
    ) -> None:
        names = message.get("channel_names")
        sample_rate = message.get("sample_rate_hz")
        source = message.get("source")
        if (
            not isinstance(names, list)
            or not names
            or not all(isinstance(name, str) and name for name in names)
            or not isinstance(sample_rate, (int, float))
            or not math.isfinite(sample_rate)
            or sample_rate <= 0
            or (
                source is not None
                and source
                not in {"recorded_replay", "live_unicorn", "live_ant"}
            )
        ):
            raise ValueError("EEG metadata is missing channels or sample rate")
        by_upper = {name.upper(): index for index, name in enumerate(names)}
        selected = [
            (name, by_upper[name.upper()])
            for name in self._requested_channels
            if name.upper() in by_upper
        ]
        if not selected:
            raise ValueError(
                "EEG stream has none of the requested panel channels: "
                + ", ".join(self._requested_channels)
            )
        max_samples = max(2, round(self._window_seconds * float(sample_rate)))
        with self._lock:
            self._channel_names = tuple(name for name, _ in selected)
            self._channel_indices = tuple(index for _, index in selected)
            self._times = deque(maxlen=max_samples)
            self._values = [deque(maxlen=max_samples) for _ in selected]
            self._timestamp_origin = None
            self._next_sequence = 0
            self._status = "streaming"
            self._error = None
            self._source = source
            self._is_replay_fallback = is_replay_fallback
            if not is_replay_fallback:
                self._notice = None

    def _handle_samples(self, message: dict) -> None:
        timestamps = message.get("timestamps_s")
        values = message.get("values_uv")
        sequence = message.get("sequence")
        if (
            not isinstance(timestamps, list)
            or not timestamps
            or not isinstance(values, list)
            or not isinstance(sequence, int)
        ):
            raise ValueError("EEG sample message is malformed")
        with self._lock:
            if not self._channel_indices:
                raise ValueError("EEG samples arrived before metadata")
            if sequence < self._next_sequence:
                raise ValueError("EEG sample sequence moved backwards")
            if sequence > self._next_sequence:
                self._times.clear()
                for channel in self._values:
                    channel.clear()
            self._next_sequence = sequence + 1
            if self._timestamp_origin is None:
                self._timestamp_origin = float(timestamps[0])
            if len(timestamps) == 0:
                raise ValueError("EEG sample message contains no timestamps")
            for channel_index in self._channel_indices:
                if (
                    channel_index >= len(values)
                    or not isinstance(values[channel_index], list)
                    or len(values[channel_index]) != len(timestamps)
                ):
                    raise ValueError("EEG sample shape does not match metadata")
            normalized_times = [
                float(timestamp) - self._timestamp_origin for timestamp in timestamps
            ]
            if not all(math.isfinite(timestamp) for timestamp in normalized_times):
                raise ValueError("EEG sample contains a non-finite timestamp")
            self._times.extend(normalized_times)
            for target, channel_index in zip(self._values, self._channel_indices):
                channel_values = [float(value) for value in values[channel_index]]
                if not all(math.isfinite(value) for value in channel_values):
                    raise ValueError("EEG sample contains a non-finite voltage")
                target.extend(channel_values)

    def _set_error(self, message: str) -> None:
        with self._lock:
            self._status = "error"
            self._error = message
