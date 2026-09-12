"""NeuroLoop -- closed-loop EEG lapse prediction.

Team <NUMBER>: <MEMBER NAMES>
NOVA Buildathon 2026 / ANT Neuro challenge.
"""

from importlib import import_module
from types import ModuleType

__all__ = ["features", "io"]


def __getattr__(name: str) -> ModuleType:
    """Load optional numerical modules only when callers request them."""
    if name not in __all__:
        raise AttributeError(f"module {__name__!r} has no attribute {name!r}")
    module = import_module(f".{name}", __name__)
    globals()[name] = module
    return module
