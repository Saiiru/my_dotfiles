#!/usr/bin/env bash
# Simple wf-recorder wrapper with toggle logic.

set -euo pipefail

PID_FILE="/tmp/wf-recorder.pid"
OUT_DIR="${SCREENRECORD_DIR:-$HOME/Videos/Recordings}"
mkdir -p "$OUT_DIR"

stop_recording() {
    if [[ -f "$PID_FILE" ]]; then
        local pid
        pid="$(cat "$PID_FILE")"
        if kill -0 "$pid" 2>/dev/null; then
            kill -INT "$pid"
            wait "$pid" 2>/dev/null || true
        fi
        rm -f "$PID_FILE"
        ~/.config/hypr/scripts/red-hood-notify.sh effect "Recording stopped"
    fi
}

mode="${1:-region}"

case "$mode" in
    --stop)
        stop_recording
        ;;
    --fullscreen|--fullscreen-sound)
        if [[ -f "$PID_FILE" ]] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
            stop_recording
            exit 0
        fi
        outfile="$OUT_DIR/full-$(date +%Y%m%d-%H%M%S).mp4"
        cmd=(wf-recorder -f "$outfile")
        [[ "$mode" == "--fullscreen-sound" ]] && cmd+=(-a)
        "${cmd[@]}" &
        echo $! > "$PID_FILE"
        ~/.config/hypr/scripts/red-hood-notify.sh effect "Recording fullscreen → $(basename "$outfile")"
        ;;
    *)
        if [[ -f "$PID_FILE" ]] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
            stop_recording
            exit 0
        fi
        region="$(slurp)"
        [[ -z "$region" ]] && exit 0
        outfile="$OUT_DIR/region-$(date +%Y%m%d-%H%M%S).mp4"
        wf-recorder -g "$region" -f "$outfile" &
        echo $! > "$PID_FILE"
        ~/.config/hypr/scripts/red-hood-notify.sh effect "Recording region → $(basename "$outfile")"
        ;;
esac
