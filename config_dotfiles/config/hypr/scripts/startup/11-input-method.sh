#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Starts the Fcitx5 input method editor

iDIR="$HOME/.config/swaync/images" # For notify-send icons

# --- Dependency Check ---
check_dependency() {
    command -v "$1" >/dev/null 2>&1 || { notify-send -i "$iDIR/error.png" "Error: Missing Dependency" "$1 is not installed. Aborting."; exit 1; }
}

check_dependency "fcitx5"
check_dependency "notify-send"

# Starts the Fcitx5 input method editor
fcitx5 &
if [ $? -eq 0 ]; then
    notify-send -u low -i "$iDIR/ja.png" "Input Method" "Fcitx5 input method started."
else
    notify-send -i "$iDIR/error.png" "Error: Input Method" "Failed to start Fcitx5 input method."
fi
