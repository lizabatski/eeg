"""Run a short 30-trial flanker calibration/demo with the embedded EEG panel.

Team: Monster's Inc

A shortened version of scripts/09_flanker_task.py (30 trials, one
intervention-enabled block, a 60-second calibration) intended for live
demonstrations rather than data collection. Wires up either the experimental
:class:`~neuroloop.loop.LiveEngine` (real ANT LSL stream + trained model) or
the seeded :class:`~neuroloop.loop.MockEngine`, and hands it to
:func:`flanker.task.run_experiment`, which owns the actual trial loop.
"""
from __future__ import annotations

import argparse
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))

from flanker.eeg_panel import eeg_websocket_url
from flanker.task import run_experiment
from neuroloop.loop import LiveEngine, MockEngine


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--participant", required=True, help="Participant identifier")
    parser.add_argument("--seed", type=int, default=0, help="Trial-order seed")
    parser.add_argument(
        "--engine",
        choices=("live", "mock"),
        default="live",
        help="Intervention engine; mock must be selected explicitly",
    )
    parser.add_argument("--ant-lsl-stream-name", help="Exact live ANT LSL stream name")
    parser.add_argument(
        "--model-path",
        type=Path,
        default=ROOT / "artifacts" / "cogbci_flanker_live_model.joblib",
    )
    parser.add_argument(
        "--classifier-replay-file",
        type=Path,
        default=(
            ROOT
            / "EEG_flipcup"
            / "Ewing_Patrick_2026-08-10_13-07-25_session-01.cnt"
        ),
    )
    parser.add_argument("--risk-threshold", type=float, default=0.5)
    parser.add_argument("--risk-rearm-threshold", type=float, default=0.45)
    parser.add_argument("--intervention-cooldown", type=float, default=10.0)
    parser.add_argument(
        "--calibration-seconds",
        type=float,
        default=60.0,
        help="Demo calibration duration; 60 seconds permits 30 clean windows",
    )
    parser.add_argument(
        "--engine-threshold",
        type=float,
        default=0.6,
        help="MockEngine intervention threshold",
    )
    parser.add_argument(
        "--eeg-websocket-url",
        default="ws://127.0.0.1:8765/",
        help="EEG WebSocket server used by the embedded panel",
    )
    parser.add_argument(
        "--eeg-source",
        choices=("replay", "unicorn", "ant"),
        default="ant",
        help="EEG source requested from the WebSocket server",
    )
    parser.add_argument(
        "--no-eeg-panel",
        action="store_true",
        help="Disable the embedded EEG panel",
    )
    parser.add_argument(
        "--require-live-eeg",
        action="store_true",
        help="Fail visibly instead of using flip-cup replay when live EEG fails",
    )
    args = parser.parse_args()
    if not 0 <= args.engine_threshold <= 1:
        parser.error("--engine-threshold must be between 0 and 1")
    if not 0 < args.risk_threshold < 1:
        parser.error("--risk-threshold must be between zero and one")
    if not 0 <= args.risk_rearm_threshold < args.risk_threshold:
        parser.error("--risk-rearm-threshold must be below --risk-threshold")
    if args.intervention_cooldown < 0:
        parser.error("--intervention-cooldown cannot be negative")
    if args.calibration_seconds <= 0:
        parser.error("--calibration-seconds must be positive")
    if args.engine == "live":
        if not args.ant_lsl_stream_name:
            parser.error("--ant-lsl-stream-name is required with --engine live")
        if not args.model_path.is_file():
            parser.error(
                f"Model artifact not found: {args.model_path}. "
                "Run scripts/11_train_live_model.py first."
            )
        engine = LiveEngine(
            stream_name=args.ant_lsl_stream_name,
            model_path=args.model_path,
            threshold=args.risk_threshold,
            rearm_threshold=args.risk_rearm_threshold,
            cooldown_seconds=args.intervention_cooldown,
            allow_replay=not args.require_live_eeg,
            replay_path=args.classifier_replay_file,
        )
        engine_mode = "live_experimental"
        model_id = engine.model_id
        feedback_heading = "Experimental Flanker lapse risk"
    else:
        engine = MockEngine(seed=args.seed, threshold=args.engine_threshold)
        engine_mode = "mock"
        model_id = ""
        feedback_heading = "Mental state feedback (simulation)"

    output = run_experiment(
        participant=args.participant,
        engine=engine,
        seed=args.seed,
        first_condition="intervention",
        output_dir=ROOT / "results",
        eeg_websocket_url=(
            None
            if args.no_eeg_panel
            else eeg_websocket_url(args.eeg_websocket_url, args.eeg_source)
        ),
        eeg_fallback_websocket_url=(
            eeg_websocket_url(args.eeg_websocket_url, "replay")
            if (
                not args.no_eeg_panel
                and not args.require_live_eeg
                and args.eeg_source != "replay"
            )
            else None
        ),
        trials_per_block=30,
        condition_sequence=(True,),
        engine_mode=engine_mode,
        model_id=model_id,
        feedback_heading=feedback_heading,
        calibration_seconds=args.calibration_seconds,
    )
    print(output)


if __name__ == "__main__":
    main()
