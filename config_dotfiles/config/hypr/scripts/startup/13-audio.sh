#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Starts the EasyEffects audio processing service

iDIR="$HOME/.config/swaync/images" # For notify-send icons

# --- Dependency Check ---
check_dependency() {
    command -v "$1" >/dev/null 2>&1 || { notify-send -i "$iDIR/error.png" "Error: Missing Dependency" "$1 is not installed. Aborting."; exit 1; }
}

check_dependency "easyeffects"
check_dependency "notify-send"

# Starts the EasyEffects audio processing service
easyeffects --gapplication-service &
if [ $? -eq 0 ]; then
    notify-send -u low -i "$iDIR/ja.png" "Audio" "EasyEffects audio processing service started."
else
    notify-send -i "$iDIR/error.png" "Error: Audio" "Failed to start EasyEffects audio processing service."
fi
