#!/usr/bin/env bash
# Hyprland holographic border controller

set -euo pipefail

declare -A SCHEMES=(
    [redhood]="rgb(dc143c) rgb(ff6600) rgb(ff073a) 45deg"
    [outlaw]="rgb(ff073a) rgb(ee79d1) rgb(7c3aed) 45deg"
    [toxic]="rgb(22e3b3) rgb(facc15) rgb(ff6600) 45deg"
    [electric]="rgb(22d3ee) rgb(7c3aed) rgb(ee79d1) 45deg"
    [inferno]="rgb(ff6600) rgb(dc143c) rgb(0a0b0d) 45deg"
    [ghost]="rgb(e6edf3) rgb(22d3ee) rgb(7c3aed) 45deg"
)

INDEX_FILE="/tmp/hypr-border-scheme-index"
STATE_FILE="/tmp/hypr-border-state"

get_index() {
    [[ -f "$INDEX_FILE" ]] && cat "$INDEX_FILE" || echo 0
}

set_border() {
    local scheme="$1"
    hyprctl keyword general:col.active_border "$scheme" >/dev/null
    hyprctl keyword misc:col_border_angle_speed 220 >/dev/null
    echo "$scheme" > "$STATE_FILE"
}

notify() {
    local message="$1"
    if [[ -x ~/.config/hypr/scripts/red-hood-notify.sh ]]; then
        ~/.config/hypr/scripts/red-hood-notify.sh border "$message"
    fi
}

case "${1:-cycle}" in
    init)
        set_border "${SCHEMES[redhood]}"
        echo 0 > "$INDEX_FILE"
        notify "Red Hood borders armed"
        ;;
    cycle)
        local schemes=(redhood outlaw toxic electric inferno ghost)
        local current next selection
        current="$(get_index)"
        next=$(( (current + 1) % ${#schemes[@]} ))
        selection="${schemes[$next]}"
        set_border "${SCHEMES[$selection]}"
        echo "$next" > "$INDEX_FILE"
        notify "Scheme → ${selection}"
        ;;
    random)
        local schemes=(redhood outlaw toxic electric inferno ghost)
        local pick="${schemes[RANDOM % ${#schemes[@]}]}"
        set_border "${SCHEMES[$pick]}"
        notify "Random scheme → ${pick}"
        ;;
    reset)
        set_border "${SCHEMES[redhood]}"
        echo 0 > "$INDEX_FILE"
        notify "Borders reset"
        ;;
    glitch)
        local schemes=(redhood outlaw toxic electric inferno ghost)
        for _ in {1..12}; do
            local pick="${schemes[RANDOM % ${#schemes[@]}]}"
            set_border "${SCHEMES[$pick]}"
            sleep 0.05
        done
        set_border "${SCHEMES[redhood]}"
        notify "Glitch sweep complete"
        ;;
    pulse)
        local speeds=(40 70 100 150 220 260 220 150 100 70)
        for speed in "${speeds[@]}"; do
            hyprctl keyword misc:col_border_angle_speed "$speed" >/dev/null
            sleep 0.15
        done
        hyprctl keyword misc:col_border_angle_speed 200 >/dev/null
        notify "Pulse cycle finished"
        ;;
    *)
        echo "Usage: $(basename "$0") {init|cycle|random|reset|glitch|pulse}" >&2
        exit 1
        ;;
esac
