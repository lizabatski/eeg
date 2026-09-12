"""
Closed-loop interface. This is the contract between the EEG pipeline and the
flanker task -- the only surface the two halves share.

Team <NUMBER>: <MEMBER NAMES>

The task POLLS and never blocks. It calls state() just before presenting a
stimulus and acts on what comes back. A background reader keeps the estimate
fresh; state() only ever reads a cached value, so a stalled amplifier returns
a stale flag rather than freezing stimulus timing.

Build against MockEngine now. Swap in LiveEngine later -- same interface, so
no task code changes.
"""

from __future__ import annotations

import asyncio
import math
from pathlib import Path
import random
import threading
import time
from dataclasses import dataclass
from typing import Any, Callable, Protocol

import numpy as np

from .eeg_sources import AntLslSource, RecordedReplaySource
from .live_model import (
    CausalBandpass,
    DeploymentModel,
    MODEL_CHANNELS,
    UPDATE_SECONDS,
    WINDOW_SECONDS,
    extract_model_vector,
    load_deployment_model,
    window_is_clean,
)


@dataclass(frozen=True)
class LoopState:
    """What the task gets back. Immutable snapshot."""

    lapse_probability: float
    intervene: bool
    status: str          # "ok" | "stale" | "uncalibrated"
    n_windows: int       # windows seen since start; useful for logging
    risk_high: bool | None = None
    source: str | None = None

    @property
    def usable(self) -> bool:
        return self.status == "ok"


class LoopEngine(Protocol):
    """Implemented by both MockEngine and the real one."""

    def start(self) -> None:
        """Begin acquiring. Returns immediately."""

    def calibrate(self, seconds: float) -> None:
        """Collect the baseline block and fit thresholds, EOG coefficients and
        the feature normaliser. Blocking -- call before the task starts."""

    def state(self) -> LoopState:
        """Current estimate. Must not block."""

    def mark(self, code: int, label: str = "") -> None:
        """Task reports a trial event, for alignment and offline re-analysis."""

    def stop(self) -> None:
        """Stop acquiring and flush logs."""


class MockEngine:
    """Fake engine so the task can be built and tested with no hardware.

    Drifts a probability with a slow random walk so interventions arrive in
    plausible clusters rather than uniformly at random -- which is what the
    real slow attentional signal is expected to look like, and it exercises
    the task's handling of runs of interventions.
    """

    def __init__(
        self,
        threshold: float = 0.6,
        seed: int | None = None,
        stale_rate: float = 0.02,
    ) -> None:
        self.threshold = threshold
        self.stale_rate = stale_rate
        self._rng = random.Random(seed)
        self._p = 0.4
        self._n = 0
        self._calibrated = False
        self._running = False
        self.marks: list[tuple[float, int, str]] = []

    def start(self) -> None:
        self._running = True

    def calibrate(self, seconds: float) -> None:
        time.sleep(min(seconds, 0.1))  # do not actually stall a test run
        self._calibrated = True

    def state(self) -> LoopState:
        if not self._calibrated:
            return LoopState(0.0, False, "uncalibrated", self._n, None, "mock")

        self._n += 1
        self._p = min(0.95, max(0.05, self._p + self._rng.gauss(0, 0.08)))

        if self._rng.random() < self.stale_rate:
            return LoopState(
                self._p,
                False,
                "stale",
                self._n,
                self._p > self.threshold,
                "mock",
            )

        high = self._p > self.threshold
        return LoopState(self._p, high, "ok", self._n, high, "mock")

    def mark(self, code: int, label: str = "") -> None:
        self.marks.append((time.time(), code, label))

    def stop(self) -> None:
        self._running = False


class LiveEngine:
    """Non-blocking experimental Flip Cup failure-risk engine for ANT LSL."""

    def __init__(
        self,
        *,
        stream_name: str,
        model_path: str | Path | None = None,
        model: DeploymentModel | None = None,
        threshold: float = 0.5,
        rearm_threshold: float | None = None,
        cooldown_seconds: float = 10.0,
        stale_seconds: float = 2.0,
        resolve_timeout: float = 5.0,
        allow_replay: bool = False,
        replay_path: str | Path | None = None,
        replay_speed: float = 1.0,
        source_factory: Callable[[], Any] | None = None,
        monotonic: Callable[[], float] = time.monotonic,
    ) -> None:
        if model is None and model_path is None:
            raise ValueError("LiveEngine requires a trained model artifact")
        if not stream_name.strip() and source_factory is None:
            raise ValueError("LiveEngine requires an ANT LSL stream name")
        if not 0 < threshold < 1:
            raise ValueError("LiveEngine threshold must be between zero and one")
        if rearm_threshold is None:
            rearm_threshold = max(0.0, threshold - 0.05)
        if not 0 <= rearm_threshold < threshold:
            raise ValueError("Re-arm threshold must be below the risk threshold")
        if cooldown_seconds < 0 or stale_seconds <= 0 or resolve_timeout <= 0:
            raise ValueError("LiveEngine timing values must be positive")
        if replay_speed <= 0:
            raise ValueError("Replay speed must be positive")
        if allow_replay and replay_path is None and source_factory is None:
            raise ValueError("Replay-enabled LiveEngine requires a recording path")
        self.model = model or load_deployment_model(model_path)
        self.threshold = threshold
        self.rearm_threshold = rearm_threshold
        self.cooldown_seconds = cooldown_seconds
        self.stale_seconds = stale_seconds
        self._monotonic = monotonic
        self._allow_replay = allow_replay
        if source_factory is not None:
            self._source_factory = source_factory
        else:
            def create_source() -> Any:
                try:
                    return AntLslSource(
                        stream_name,
                        resolve_timeout=resolve_timeout,
                        chunk_seconds=0.05,
                        requested_channels=list(MODEL_CHANNELS),
                        idle_timeout=stale_seconds,
                    )
                except (ConnectionError, OSError, ValueError):
                    if not allow_replay:
                        raise
                    return RecordedReplaySource(
                        Path(replay_path),
                        duration_seconds=24 * 60 * 60,
                        chunk_seconds=0.05,
                        speed=replay_speed,
                        channels=list(MODEL_CHANNELS),
                        loop=True,
                    )

            self._source_factory = create_source
        self._lock = threading.RLock()
        self._condition = threading.Condition(self._lock)
        self._stop_event = threading.Event()
        self._thread: threading.Thread | None = None
        self._running = False
        self._calibration_requested = False
        self._calibration_seconds = 0.0
        self._calibration_started_at: float | None = None
        self._calibration_clean_windows = 0
        self._calibrated = False
        self._error: str | None = None
        self._last_data_at: float | None = None
        self._last_prediction_at: float | None = None
        self._probability = 0.0
        self._data_source: str | None = None
        self._n_windows = 0
        self._armed = True
        self._pending_intervention = False
        self._last_intervention_at = -math.inf
        self.marks: list[tuple[float, int, str]] = []

    @property
    def model_id(self) -> str:
        return self.model.model_id

    @property
    def last_error(self) -> str | None:
        with self._lock:
            return self._error

    def start(self) -> None:
        with self._lock:
            if self._running:
                raise RuntimeError("LiveEngine is already running")
            self._running = True
            self._stop_event.clear()
            self._thread = threading.Thread(
                target=self._thread_main,
                name="ant-live-engine",
                daemon=True,
            )
            self._thread.start()

    def calibrate(self, seconds: float) -> None:
        if seconds <= 0:
            raise ValueError("Calibration duration must be positive")
        with self._condition:
            if not self._running:
                if self._error is not None:
                    self._calibrated = True
                    return
                raise RuntimeError("LiveEngine must be started before calibration")
            self._calibration_requested = True
            self._calibration_seconds = float(seconds)
            self._calibration_started_at = None
            self._calibration_clean_windows = 0
            self._calibrated = False
            while (
                self._running
                and not self._calibrated
                and self._error is None
            ):
                self._condition.wait(timeout=0.25)
            if self._error is not None:
                self._calibrated = True
                return
            if not self._calibrated:
                raise RuntimeError("LiveEngine stopped before calibration completed")

    def state(self) -> LoopState:
        now = self._monotonic()
        with self._lock:
            if not self._calibrated:
                return LoopState(
                    self._probability,
                    False,
                    "uncalibrated",
                    self._n_windows,
                    None,
                    self._data_source,
                )
            fresh = (
                self._error is None
                and self._last_data_at is not None
                and self._last_prediction_at is not None
                and now - self._last_data_at <= self.stale_seconds
                and now - self._last_prediction_at <= self.stale_seconds
            )
            if not fresh:
                return LoopState(
                    self._probability,
                    False,
                    "stale",
                    self._n_windows,
                    self._probability >= self.threshold,
                    self._data_source,
                )
            intervene = self._pending_intervention
            self._pending_intervention = False
            return LoopState(
                self._probability,
                intervene,
                "ok",
                self._n_windows,
                self._probability >= self.threshold,
                self._data_source,
            )

    def mark(self, code: int, label: str = "") -> None:
        with self._lock:
            self.marks.append((time.time(), code, label))

    def stop(self) -> None:
        self._stop_event.set()
        with self._condition:
            self._running = False
            self._condition.notify_all()
        if self._thread is not None:
            self._thread.join(timeout=3.0)

    def _thread_main(self) -> None:
        try:
            asyncio.run(self._reader())
        except Exception as exc:
            with self._condition:
                if not self._stop_event.is_set():
                    self._error = str(exc)
                self._running = False
                self._condition.notify_all()

    async def _reader(self) -> None:
        source = await asyncio.to_thread(self._source_factory)
        try:
            if source.metadata.source not in {"live_ant", "recorded_replay"}:
                raise ValueError("LiveEngine received an unsupported EEG source")
            if source.metadata.source == "recorded_replay" and not self._allow_replay:
                raise ValueError(
                    "LiveEngine accepts live ANT data only; replay cannot "
                    "drive interventions"
                )
            if tuple(source.metadata.channel_names) != MODEL_CHANNELS:
                raise ValueError(
                    "Live ANT source channel order does not match model contract"
                )
            sample_rate = float(source.metadata.sample_rate_hz)
            with self._lock:
                self._data_source = source.metadata.source
            filter_ = CausalBandpass(sample_rate, len(MODEL_CHANNELS))
            required_samples = round(WINDOW_SECONDS * sample_rate)
            max_buffer_samples = required_samples + round(sample_rate)
            buffer = np.empty((len(MODEL_CHANNELS), 0), dtype=float)
            last_processed_timestamp: float | None = None
            last_calibration_timestamp: float | None = None
            async for chunk in source.chunks():
                if self._stop_event.is_set():
                    break
                values_uv = np.asarray(chunk.values_uv, dtype=float)
                if values_uv.shape[0] != len(MODEL_CHANNELS):
                    raise ValueError("Live ANT chunk does not match model channels")
                filtered = filter_.process(values_uv * 1e-6)
                buffer = np.concatenate((buffer, filtered), axis=1)
                if buffer.shape[1] > max_buffer_samples:
                    buffer = buffer[:, -max_buffer_samples:]
                source_time = float(chunk.timestamps_s[-1])
                observed_at = self._monotonic()
                with self._condition:
                    self._last_data_at = observed_at
                    if (
                        self._calibration_requested
                        and self._calibration_started_at is None
                    ):
                        self._calibration_started_at = observed_at
                if buffer.shape[1] < required_samples:
                    continue
                window = buffer[:, -required_samples:]
                if (
                    self._calibration_requested
                    and (
                        last_calibration_timestamp is None
                        or source_time - last_calibration_timestamp
                        >= WINDOW_SECONDS - (0.5 / sample_rate)
                    )
                ):
                    last_calibration_timestamp = source_time
                    if window_is_clean(window):
                        with self._condition:
                            self._calibration_clean_windows += 1
                self._complete_calibration_if_ready(observed_at)
                with self._lock:
                    calibrated = self._calibrated
                if (
                    calibrated
                    and (
                        last_processed_timestamp is None
                        or source_time - last_processed_timestamp >= UPDATE_SECONDS
                    )
                ):
                    last_processed_timestamp = source_time
                    if not window_is_clean(window):
                        continue
                    vector = extract_model_vector(window, sample_rate)
                    probability = self.model.predict_failure_probability(vector)
                    self._accept_probability(probability, observed_at)
        finally:
            await asyncio.to_thread(source.close)

    def _complete_calibration_if_ready(self, observed_at: float) -> None:
        with self._condition:
            if (
                not self._calibration_requested
                or self._calibration_started_at is None
                or observed_at - self._calibration_started_at
                < self._calibration_seconds
            ):
                return
            if self._calibration_clean_windows < 30:
                self._error = (
                    "Calibration produced "
                    f"{self._calibration_clean_windows} clean windows; "
                    "at least 30 are required"
                )
                self._condition.notify_all()
                return
            self._calibration_requested = False
            self._calibrated = True
            self._condition.notify_all()

    def _accept_probability(self, probability: float, observed_at: float) -> None:
        if not 0 <= probability <= 1 or not math.isfinite(probability):
            raise ValueError("Live model probability must be between zero and one")
        with self._lock:
            self._probability = probability
            self._last_prediction_at = observed_at
            self._n_windows += 1
            if probability < self.rearm_threshold:
                self._armed = True
            if (
                probability >= self.threshold
                and self._armed
                and observed_at - self._last_intervention_at
                >= self.cooldown_seconds
            ):
                self._pending_intervention = True
                self._armed = False
                self._last_intervention_at = observed_at
