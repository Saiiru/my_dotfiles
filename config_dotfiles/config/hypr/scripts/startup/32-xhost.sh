#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Allows local connections to the X server

iDIR="$HOME/.config/swaync/images" # For notify-send icons

# --- Dependency Check ---
check_dependency() {
    command -v "$1" >/dev/null 2>&1 || { notify-send -i "$iDIR/error.png" "Error: Missing Dependency" "$1 is not installed. Aborting."; exit 1; }
}

check_dependency "xhost"
check_dependency "notify-send"

# Allows local connections to the X server
xhost +local:
if [ $? -eq 0 ]; then
    notify-send -u low -i "$iDIR/ja.png" "X Server" "Local X server connections enabled."
else
    notify-send -i "$iDIR/error.png" "Error: X Server" "Failed to enable local X server connections."
fi
