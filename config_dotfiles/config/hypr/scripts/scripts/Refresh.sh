#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Scripts for refreshing waybar, rofi, swaync, wallust

SCRIPTSDIR=$HOME/.config/hypr/scripts
UserScripts=$HOME/.config/hypr/UserScripts

# --- Dependency Check ---
check_dependency() {
    command -v "$1" >/dev/null 2>&1 || { echo >&2 "Error: Missing Dependency: $1. Aborting."; exit 1; }
}

check_dependency "waybar"
check_dependency "rofi"
check_dependency "swaync"
check_dependency "swaync-client"
check_dependency "pidof"
check_dependency "killall"
# check_dependency "$UserScripts/RainbowBorders.sh" # This is checked with file_exists

# Define file_exists function
file_exists() {
    if [ -e "$1" ]; then
        return 0  # File exists
    else
        return 1  # File does not exist
    fi
}

# Kill already running processes
_ps=(waybar rofi swaync) # Removed ags
for _prs in "${_ps[@]}"; do
    if pidof "${_prs}" >/dev/null; then
        pkill "${_prs}" || true
    fi
done

# added since wallust sometimes not applying
killall -SIGUSR2 waybar || true

# some process to kill
for pid in $(pidof waybar rofi swaync swaybg); do # Removed ags
    kill -SIGUSR1 "$pid" || true
done

#Restart waybar
sleep 1
waybar &

# relaunch swaync
sleep 0.5
swaync > /dev/null 2>&1 &
# reload swaync
swaync-client --reload-config

# Relaunching rainbow borders if the script exists
sleep 1
if file_exists "${UserScripts}/RainbowBorders.sh"; then
    "${UserScripts}/RainbowBorders.sh" &
fi

exit 0