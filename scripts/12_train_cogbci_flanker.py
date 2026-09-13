"""Train and save the experimental COG-BCI Flanker lapse model.

Team: Monster's Inc

Thin CLI wrapper around :func:`neuroloop.cogbci_model.train_cogbci_model`
(leave-one-participant-out evaluation, then a final pooled fit -- see that
module's docstring for the full algorithm) and
:func:`~neuroloop.live_model.save_deployment_model`.
"""
from __future__ import annotations

import argparse
import json
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))

from neuroloop.cogbci_model import train_cogbci_model
from neuroloop.live_model import save_deployment_model


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--data-root",
        type=Path,
        default=ROOT / "data" / "cogbci",
    )
    parser.add_argument(
        "--model",
        type=Path,
        default=ROOT / "artifacts" / "cogbci_flanker_live_model.joblib",
    )
    parser.add_argument(
        "--manifest",
        type=Path,
        default=ROOT / "artifacts" / "cogbci_flanker_live_model.json",
    )
    parser.add_argument("--subjects", nargs="+", type=int, help="Explicit participant IDs (all three sessions required)")
    args = parser.parse_args()

    model = train_cogbci_model(args.data_root, subjects=args.subjects)
    save_deployment_model(model, args.model, args.manifest)
    print(json.dumps(model.manifest(), indent=2))
    print(f"Saved model: {args.model}")
    print(f"Saved manifest: {args.manifest}")


if __name__ == "__main__":
    main()
