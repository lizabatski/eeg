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

import random
import time
from dataclasses import dataclass
from typing import Protocol


@dataclass(frozen=True)
class LoopState:
    """What the task gets back. Immutable snapshot."""

    lapse_probability: float
    intervene: bool
    status: str          # "ok" | "stale" | "uncalibrated"
    n_windows: int       # windows seen since start; useful for logging

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
            return LoopState(0.0, False, "uncalibrated", self._n)

        self._n += 1
        self._p = min(0.95, max(0.05, self._p + self._rng.gauss(0, 0.08)))

        if self._rng.random() < self.stale_rate:
            return LoopState(self._p, False, "stale", self._n)

        return LoopState(self._p, self._p > self.threshold, "ok", self._n)

    def mark(self, code: int, label: str = "") -> None:
        self.marks.append((time.time(), code, label))

    def stop(self) -> None:
        self._running = False
