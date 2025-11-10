#!/usr/bin/env bash
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Screen Recorder - Unified Script
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

set -euo pipefail

get_date() {
    date '+%Y-%m-%d_%H.%M.%S'
}

get_audio_output() {
    pactl list sources | grep 'Name' | grep 'monitor' | cut -d ' ' -f2 | head -n 1
}

get_active_monitor() {
    hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name'
}

RECORDINGS_DIR="$(xdg-user-dir VIDEOS)/Recordings"
mkdir -p "$RECORDINGS_DIR"

if pgrep -x wf-recorder > /dev/null; then
    pkill -x wf-recorder
    notify-send "🎥 Recording Stopped" "Video saved in $RECORDINGS_DIR" -a 'Recorder'
else
    output_file="$RECORDINGS_DIR/rec-$(get_date).mp4"
    notify-send "🔴 Recording Started" "Press the keybind again to stop." -a 'Recorder'

    if [[ "$1" == "--sound" ]]; then
        wf-recorder --pixel-format yuv420p -f "$output_file" -t --geometry "$(slurp)" --audio="$(get_audio_output)" & disown
    elif [[ "$1" == "--fullscreen-sound" ]]; then
        wf-recorder -o $(get_active_monitor) --pixel-format yuv420p -f "$output_file" -t --audio="$(get_audio_output)" & disown
    elif [[ "$1" == "--fullscreen" ]]; then
        wf-recorder -o $(get_active_monitor) --pixel-format yuv420p -f "$output_file" -t & disown
    else # Gravação de região sem som por padrão
        wf-recorder --pixel-format yuv420p -f "$output_file" -t --geometry "$(slurp)" & disown
    fi
fi
