#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Starts Hyprland-specific daemons

iDIR="$HOME/.config/swaync/images" # For notify-send icons

# --- Dependency Check ---
check_dependency() {
    command -v "$1" >/dev/null 2>&1 || { notify-send -i "$iDIR/error.png" "Error: Missing Dependency" "$1 is not installed. Aborting."; exit 1; }
}

check_dependency "hyprswitch"
check_dependency "hypridle"
check_dependency "notify-send"

# Starts hyprswitch
hyprswitch init &
if [ $? -eq 0 ]; then
    notify-send -u low -i "$iDIR/ja.png" "Hyprland Daemon" "Hyprswitch daemon started."
else
    notify-send -i "$iDIR/error.png" "Error: Hyprland Daemon" "Failed to start Hyprswitch daemon."
fi

# Starts hypridle
hypridle &
if [ $? -eq 0 ]; then
    notify-send -u low -i "$iDIR/ja.png" "Hyprland Daemon" "Hypridle daemon started."
else
    notify-send -i "$iDIR/error.png" "Error: Hyprland Daemon" "Failed to start Hypridle daemon."
fi
