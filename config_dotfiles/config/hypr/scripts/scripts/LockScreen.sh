#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##

# For Hyprlock

# Directory for swaync images (for notify-send)
iDIR="$HOME/.config/swaync/images"

# --- Dependency Check ---
check_dependency() {
    command -v "$1" >/dev/null 2>&1 || { notify-send -i "$iDIR/error.png" "Error: Missing Dependency" "$1 is not installed. Aborting."; exit 1; }
}

check_dependency "hyprlock"
check_dependency "notify-send"
check_dependency "$HOME/.config/hypr/UserScripts/WeatherWrap.sh"

# Ensure weather cache is up-to-date before locking (Waybar/lockscreen readers)
bash "$HOME/.config/hypr/UserScripts/WeatherWrap.sh" >/dev/null 2>&1 || notify-send -i "$iDIR/error.png" "Weather Update Failed" "Failed to update weather data before locking."

hyprlock || notify-send -i "$iDIR/error.png" "Screen Lock Failed" "Failed to launch hyprlock."

notify-send -u low -i "$iDIR/ja.png" "Screen Locked" "Your screen has been locked."
