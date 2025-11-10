#!/usr/bin/env bash
# Launch a neon matrix screensaver in a floating Kitty window.

set -euo pipefail

if pgrep -f "kitty --class Screensaver" >/dev/null && [[ "${1:-}" != "force" ]]; then
    exit 0
fi

focused="$(hyprctl monitors -j | jq -r '.[] | select(.focused==true).name')"

for monitor in $(hyprctl monitors -j | jq -r '.[].name'); do
    hyprctl dispatch focusmonitor "$monitor"
    kitty --class Screensaver --override background=#000000 --override foreground=#dc143c \
        --override font_size=13 -e bash -c '
            if command -v cmatrix >/dev/null; then
                cmatrix -C red -u 5 -s
            elif command -v pipes.sh >/dev/null; then
                pipes.sh -t 4 -c 1,2,3
            else
                while true; do
                    printf "\033[31m%s\033[0m\n" "$(tr -dc "01" < /dev/urandom | head -c $((COLUMNS-1)))"
                    sleep 0.05
                done
            fi
        ' &
done

[[ -n "$focused" ]] && hyprctl dispatch focusmonitor "$focused"
