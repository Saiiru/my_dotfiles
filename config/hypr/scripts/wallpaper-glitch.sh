#!/usr/bin/env bash
# Wallpaper manager with glitch transitions

set -euo pipefail

DIR="${WALLPAPER_DIR:-$HOME/Pictures/Wallpapers}"
CACHE="/tmp/hypr-wallpapers.cache"
CURRENT_LINK="$HOME/.config/omarchy/current/background"

TRANSITIONS=(
    "grow --transition-duration 0.8 --transition-fps 60"
    "outer --transition-duration 0.8 --transition-fps 60"
    "wipe --transition-duration 0.8 --transition-fps 60 --transition-angle 35"
    "wave --transition-duration 1.0 --transition-fps 60 --transition-angle 90"
)

notify() {
    local message="$1"
    if [[ -x ~/.config/hypr/scripts/red-hood-notify.sh ]]; then
        ~/.config/hypr/scripts/red-hood-notify.sh wallpaper "$message"
    fi
}

build_cache() {
    mkdir -p "$DIR"
    find "$DIR" -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) \
        | sort > "$CACHE"
}

current_wallpaper() {
    [[ -L "$CURRENT_LINK" ]] && readlink -f "$CURRENT_LINK" || echo ""
}

pick_wallpaper() {
    local mode="$1" current next
    [[ -f "$CACHE" ]] || build_cache
    current="$(current_wallpaper)"
    case "$mode" in
        next)
            if [[ -n "$current" ]]; then
                next="$(grep -A1 "^$current$" "$CACHE" | tail -n1)"
                [[ -n "$next" ]] || next="$(head -n1 "$CACHE")"
            else
                next="$(head -n1 "$CACHE")"
            fi
            echo "$next"
            ;;
        prev)
            if [[ -n "$current" ]]; then
                next="$(grep -B1 "^$current$" "$CACHE" | head -n1)"
                [[ -n "$next" ]] || next="$(tail -n1 "$CACHE")"
            else
                next="$(tail -n1 "$CACHE")"
            fi
            echo "$next"
            ;;
        random)
            shuf -n1 "$CACHE"
            ;;
        select)
            if command -v rofi >/dev/null && [[ -f ~/.config/rofi/red-hood.rasi ]]; then
                local chosen
                chosen="$(sed "s|$DIR/||" "$CACHE" | rofi -dmenu -p 'Select wallpaper' -theme ~/.config/rofi/red-hood.rasi)"
                [[ -n "$chosen" ]] && echo "$DIR/$chosen"
            else
                cat "$CACHE" | fzf --prompt="Wallpaper ▸ " --preview='kitty +kitten icat --clear --stdin=no --transfer-mode=memory {}' --preview-window=down:50%
            fi
            ;;
        current)
            current_wallpaper
            ;;
    esac
}

apply_wallpaper() {
    local img="$1"
    [[ -f "$img" ]] || return 1

    local transition="${TRANSITIONS[RANDOM % ${#TRANSITIONS[@]}]}"
    if ! pgrep -x swww-daemon >/dev/null; then
        swww-daemon --format xrgb &
        sleep 0.5
    fi
    swww img "$img" --transition-type ${transition%% *} ${transition#* }

    mkdir -p "$(dirname "$CURRENT_LINK")"
    ln -sfn "$img" "$CURRENT_LINK"

    if command -v qs >/dev/null; then
        (
            sleep 0.3
            qs ipc call colorpalette extract "$img" >/dev/null 2>&1 || true
            qs ipc call colorpalette apply >/dev/null 2>&1 || true
        ) &
    fi

    notify "$(basename "$img")"
}

case "${1:-random}" in
    next|prev|random)
        selection="$(pick_wallpaper "$1")"
        [[ -n "$selection" ]] && apply_wallpaper "$selection"
        ;;
    select)
        selection="$(pick_wallpaper select)"
        [[ -n "$selection" ]] && apply_wallpaper "$selection"
        ;;
    set)
        [[ -z "${2:-}" ]] && { echo "Usage: $0 set <path>"; exit 1; }
        apply_wallpaper "$2"
        ;;
    extract)
        img="$(pick_wallpaper current)"
        if [[ -n "$img" ]] && command -v qs >/dev/null; then
        qs ipc call colorpalette extract "$img" >/dev/null 2>&1 || true
        qs ipc call colorpalette apply >/dev/null 2>&1 || true
            notify "Palette refreshed"
        fi
        ;;
    list)
        [[ -f "$CACHE" ]] || build_cache
        cat "$CACHE"
        ;;
    *)
        echo "Usage: $(basename "$0") {next|prev|random|select|set <path>|extract|list}" >&2
        exit 1
        ;;
esac
