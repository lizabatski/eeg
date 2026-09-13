"""Stream recorded ANT, live Unicorn, or live ANT LSL EEG over WebSocket.

Team: Monster's Inc

Each client connection selects a source via a ``?source=`` query parameter
(``replay``, ``unicorn``, or ``ant``); :func:`create_source` constructs the
matching :class:`~neuroloop.eeg_sources.EegSource` on a worker thread (the
underlying MNE/LSL libraries are blocking), then streams one ``metadata``
message followed by a ``samples`` message per chunk, so any number of
frontends (e.g. the PsychoPy panel or the web viewer) can watch the same kind
of EEG feed without depending on which concrete source is behind it.
"""
from __future__ import annotations

import argparse
import asyncio
from dataclasses import asdict
import json
from pathlib import Path
import sys
from urllib.parse import parse_qs, urlparse

from websockets.asyncio.server import serve
from websockets.exceptions import ConnectionClosed

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))

from neuroloop.eeg_sources import (
    AntLslSource,
    EegSource,
    RecordedReplaySource,
    UnicornLslSource,
)


DEFAULT_RECORDING = (
    ROOT / "EEG_flipcup" / "Ewing_Patrick_2026-08-10_13-07-25_session-01.cnt"
)


def _requested_source(path: str) -> str:
    values = parse_qs(urlparse(path).query).get("source", ["replay"])
    if len(values) != 1 or values[0] not in {"replay", "unicorn", "ant"}:
        raise ValueError("WebSocket source must be 'replay', 'unicorn', or 'ant'")
    return values[0]


async def _send_source(websocket, source: EegSource) -> None:
    await websocket.send(
        json.dumps(
            {
                "type": "metadata",
                "schema_version": 1,
                **asdict(source.metadata),
                "units": "microvolts",
            }
        )
    )
    final_time = 0.0
    async for chunk in source.chunks():
        final_time = chunk.timestamps_s[-1]
        await websocket.send(
            json.dumps(
                {
                    "type": "samples",
                    "sequence": chunk.sequence,
                    "timestamps_s": chunk.timestamps_s,
                    "sample_rate_hz": source.metadata.sample_rate_hz,
                    "values_uv": chunk.values_uv,
                },
                allow_nan=False,
                separators=(",", ":"),
            )
        )
    if source.metadata.source == "recorded_replay":
        await websocket.send(
            json.dumps(
                {
                    "type": "end",
                    "recording_time_s": final_time,
                }
            )
        )


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--file", type=Path, default=DEFAULT_RECORDING)
    parser.add_argument("--host", default="127.0.0.1")
    parser.add_argument("--port", type=int, default=8765)
    parser.add_argument("--seconds", type=float, default=90.0)
    parser.add_argument("--chunk-seconds", type=float, default=0.05)
    parser.add_argument("--speed", type=float, default=1.0)
    parser.add_argument("--channels", nargs="+")
    parser.add_argument("--lsl-stream-name", default="Unicorn")
    parser.add_argument("--ant-lsl-stream-name")
    parser.add_argument("--ant-channels", nargs="+")
    parser.add_argument("--lsl-timeout", type=float, default=5.0)
    args = parser.parse_args()
    if (
        args.seconds <= 0
        or args.chunk_seconds <= 0
        or args.speed <= 0
        or args.lsl_timeout <= 0
    ):
        parser.error("Replay settings and LSL timeout must be positive")

    async def create_source(source_name: str) -> EegSource:
        if source_name == "replay":
            return await asyncio.to_thread(
                RecordedReplaySource,
                args.file,
                duration_seconds=args.seconds,
                chunk_seconds=args.chunk_seconds,
                speed=args.speed,
                channels=args.channels,
            )
        if source_name == "unicorn":
            return await asyncio.to_thread(
                UnicornLslSource,
                args.lsl_stream_name,
                resolve_timeout=args.lsl_timeout,
                chunk_seconds=args.chunk_seconds,
            )
        return await asyncio.to_thread(
            AntLslSource,
            args.ant_lsl_stream_name or "",
            resolve_timeout=args.lsl_timeout,
            chunk_seconds=args.chunk_seconds,
            requested_channels=args.ant_channels,
        )

    async def handler(websocket) -> None:
        source: EegSource | None = None
        try:
            source_name = _requested_source(websocket.request.path)
            source = await create_source(source_name)
            await _send_source(websocket, source)
        except ConnectionClosed:
            return
        except Exception as exc:
            try:
                await websocket.send(
                    json.dumps({"type": "error", "message": str(exc)})
                )
                await websocket.close(1011, "EEG source failed")
            except ConnectionClosed:
                pass
        finally:
            if source is not None:
                await asyncio.to_thread(source.close)

    async def run_server() -> None:
        print(
            f"EEG WebSocket: ws://{args.host}:{args.port} "
            "(sources: replay, unicorn, ant)",
            flush=True,
        )
        async with serve(handler, args.host, args.port, max_size=None):
            await asyncio.Future()

    try:
        asyncio.run(run_server())
    except KeyboardInterrupt:
        pass


if __name__ == "__main__":
    main()
