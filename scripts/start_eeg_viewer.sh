#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PYTHON="$ROOT/.venv/bin/python"
FRONTEND="$ROOT/frontend"
SERVER_SCRIPT="$ROOT/scripts/10_eeg_wave_server.py"
RECORDING="$ROOT/EEG_flipcup/Ewing_Patrick_2026-08-10_13-07-25_session-01.cnt"
SECONDS=90
LSL_STREAM_NAME="Unicorn"

usage() {
    echo "Usage: $0 [--recording PATH] [--seconds NUMBER] [--lsl-stream-name NAME]"
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --recording)
            [[ $# -ge 2 ]] || { usage >&2; exit 2; }
            RECORDING="$2"
            shift 2
            ;;
        --seconds)
            [[ $# -ge 2 ]] || { usage >&2; exit 2; }
            SECONDS="$2"
            shift 2
            ;;
        --lsl-stream-name)
            [[ $# -ge 2 ]] || { usage >&2; exit 2; }
            LSL_STREAM_NAME="$2"
            shift 2
            ;;
        --help|-h)
            usage
            exit 0
            ;;
        *)
            echo "Unknown argument: $1" >&2
            usage >&2
            exit 2
            ;;
    esac
done

[[ -x "$PYTHON" ]] ||
    { echo "Missing .venv Python environment. Install requirements.txt first." >&2; exit 1; }
[[ -d "$FRONTEND/node_modules" ]] ||
    { echo "Missing frontend dependencies. Run npm install in frontend first." >&2; exit 1; }
[[ -f "$RECORDING" ]] ||
    { echo "EEG recording does not exist: $RECORDING" >&2; exit 1; }
"$PYTHON" -c "import sys; assert float(sys.argv[1]) > 0" "$SECONDS" 2>/dev/null ||
    { echo "Seconds must be a positive number." >&2; exit 1; }
command -v npm >/dev/null ||
    { echo "npm is required to run the viewer." >&2; exit 1; }
command -v lsof >/dev/null ||
    { echo "lsof is required to check local service readiness." >&2; exit 1; }
command -v open >/dev/null ||
    { echo "This launcher requires macOS's open command." >&2; exit 1; }

SERVER_PID=""
WEB_PID=""
cleanup() {
    if [[ -n "$WEB_PID" ]]; then
        pkill -TERM -P "$WEB_PID" 2>/dev/null || true
        kill "$WEB_PID" 2>/dev/null || true
    fi
    if [[ -n "$SERVER_PID" ]]; then
        kill "$SERVER_PID" 2>/dev/null || true
    fi
    wait "$WEB_PID" "$SERVER_PID" 2>/dev/null || true
}
trap cleanup EXIT INT TERM

"$PYTHON" "$SERVER_SCRIPT" \
    --file "$RECORDING" \
    --seconds "$SECONDS" \
    --lsl-stream-name "$LSL_STREAM_NAME" &
SERVER_PID=$!

(
    cd "$FRONTEND"
    npm run dev
) &
WEB_PID=$!

ready=false
for _ in {1..60}; do
    kill -0 "$SERVER_PID" 2>/dev/null ||
        { echo "EEG replay server exited before becoming ready." >&2; exit 1; }
    kill -0 "$WEB_PID" 2>/dev/null ||
        { echo "Frontend server exited before becoming ready." >&2; exit 1; }
    if lsof -nP -iTCP:8765 -sTCP:LISTEN >/dev/null 2>&1 &&
       lsof -nP -iTCP:5173 -sTCP:LISTEN >/dev/null 2>&1; then
        ready=true
        break
    fi
    sleep 0.25
done

[[ "$ready" == true ]] ||
    { echo "Viewer services did not become ready within 15 seconds." >&2; exit 1; }

open "http://127.0.0.1:5173"
wait "$WEB_PID"
