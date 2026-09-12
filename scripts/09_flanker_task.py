"""Run the COG-BCI-compatible PsychoPy flanker task with MockEngine."""
from __future__ import annotations

import argparse
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))

from flanker.task import run_experiment
from neuroloop.loop import MockEngine


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--participant", required=True, help="Participant identifier")
    parser.add_argument("--seed", type=int, default=0, help="Trial-order seed")
    parser.add_argument(
        "--first-condition",
        choices=("control", "intervention"),
        default="control",
        help="Condition used for the first of two blocks",
    )
    parser.add_argument(
        "--engine-threshold",
        type=float,
        default=0.6,
        help="MockEngine intervention threshold",
    )
    parser.add_argument(
        "--engine-stale-rate",
        type=float,
        default=0.02,
        help="MockEngine probability of returning a stale state",
    )
    args = parser.parse_args()
    if not 0 <= args.engine_threshold <= 1:
        parser.error("--engine-threshold must be between 0 and 1")
    if not 0 <= args.engine_stale_rate <= 1:
        parser.error("--engine-stale-rate must be between 0 and 1")

    engine = MockEngine(
        seed=args.seed,
        threshold=args.engine_threshold,
        stale_rate=args.engine_stale_rate,
    )
    output = run_experiment(
        participant=args.participant,
        engine=engine,
        seed=args.seed,
        first_condition=args.first_condition,
        output_dir=ROOT / "results",
    )
    print(output)


if __name__ == "__main__":
    main()
