"""Train and save the experimental Flip Cup model used by LiveEngine.

Team: Monster's Inc

Thin CLI wrapper around :func:`neuroloop.live_model.train_deployment_model`
(leave-one-session-out evaluation, then a final pooled fit -- see that
module's docstring for the algorithm) and
:func:`~neuroloop.live_model.save_deployment_model`.
"""
from __future__ import annotations

import argparse
import json
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))

from neuroloop.live_model import save_deployment_model, train_deployment_model


DEFAULT_SESSIONS = {
    1: ROOT
    / "EEG_flipcup"
    / "Ewing_Patrick_2026-08-10_13-07-25_session-01.cnt",
    2: ROOT
    / "EEG_flipcup"
    / "Ewing_Patrick_2026-08-10_13-07-25_session-02.cnt",
}


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--model",
        type=Path,
        default=ROOT / "artifacts" / "flipcup_live_model.joblib",
    )
    parser.add_argument(
        "--manifest",
        type=Path,
        default=ROOT / "artifacts" / "flipcup_live_model.json",
    )
    args = parser.parse_args()
    missing = [str(path) for path in DEFAULT_SESSIONS.values() if not path.is_file()]
    if missing:
        parser.error("Missing Flip Cup recording(s): " + ", ".join(missing))

    model = train_deployment_model(DEFAULT_SESSIONS)
    save_deployment_model(model, args.model, args.manifest)
    print(json.dumps(model.manifest(), indent=2))
    print(f"Saved model: {args.model}")
    print(f"Saved manifest: {args.manifest}")


if __name__ == "__main__":
    main()
