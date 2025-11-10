#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##

# Modified version of Refresh.sh but waybar wont refresh
# Used by automatic wallpaper change
# Modified inorder to refresh rofi background, Wallust, SwayNC only

SCRIPTSDIR=$HOME/.config/hypr/scripts
UserScripts=$HOME/.config/hypr/UserScripts

# --- Dependency Check ---
check_dependency() {
    command -v "$1" >/dev/null 2>&1 || { echo >&2 "Error: Missing Dependency: $1. Aborting."; exit 1; }
}

check_dependency "rofi"
check_dependency "swaync"
check_dependency "swaync-client"
check_dependency "pidof"
check_dependency "killall"
check_dependency "$SCRIPTSDIR/WallustSwww.sh"
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
_ps=(rofi)
for _prs in "${_ps[@]}"; do
    if pidof "${_prs}" >/dev/null; then
        pkill "${_prs}" || true
    fi
done

# Wallust refresh (synchronous to ensure colors are ready)
"${SCRIPTSDIR}/WallustSwww.sh"
sleep 0.2

# reload swaync
swaync-client --reload-config

# Relaunching rainbow borders if the script exists
sleep 1
if file_exists "${UserScripts}/RainbowBorders.sh"; then
    "${UserScripts}/RainbowBorders.sh" &
fi


exit 0