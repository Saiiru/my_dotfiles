#!/usr/bin/env bash
# Toggle animated border pulse

set -euo pipefail

PID_FILE="/tmp/neon-pulse.pid"

notify() {
    local message="$1"
    if [[ -x ~/.config/hypr/scripts/red-hood-notify.sh ]]; then
        ~/.config/hypr/scripts/red-hood-notify.sh effect "$message"
    fi
}

start_pulse() {
    stop_pulse >/dev/null 2>&1 || true
    (
        trap 'hyprctl keyword misc:col_border_angle_speed 200 >/dev/null' EXIT
        local speeds=(50 90 130 170 210 250 210 170 130 90)
        while true; do
            for speed in "${speeds[@]}"; do
                hyprctl keyword misc:col_border_angle_speed "$speed" >/dev/null
                sleep 0.12
            done
        done
    ) &
    echo $! > "$PID_FILE"
    notify "Neon pulse engaged"
}

stop_pulse() {
    if [[ -f "$PID_FILE" ]]; then
        local pid
        pid="$(cat "$PID_FILE")"
        if kill -0 "$pid" 2>/dev/null; then
            kill "$pid"
        fi
        rm -f "$PID_FILE"
        hyprctl keyword misc:col_border_angle_speed 200 >/dev/null
        notify "Neon pulse disabled"
        return 0
    fi
    return 1
}

case "${1:-toggle}" in
    start) start_pulse ;;
    stop) stop_pulse ;;
    toggle)
        if [[ -f "$PID_FILE" ]] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
            stop_pulse
        else
            start_pulse
        fi
        ;;
    status)
        if [[ -f "$PID_FILE" ]] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
            echo "running"
        else
            echo "stopped"
        fi
        ;;
    *)
        echo "Usage: $(basename "$0") {start|stop|toggle|status}" >&2
        exit 1
        ;;
esac
