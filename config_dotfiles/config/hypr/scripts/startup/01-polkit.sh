#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Starts the Hyprland polkit agent

iDIR="$HOME/.config/swaync/images" # For notify-send icons

# --- Dependency Check ---
check_dependency() {
    command -v "$1" >/dev/null 2>&1 || { notify-send -i "$iDIR/error.png" "Error: Missing Dependency" "$1 is not installed. Aborting."; exit 1; }
}

check_dependency "hyprpolkitagent"
check_dependency "notify-send"

# Find the hyprpolkitagent executable
HYPRPOLKITAGENT_PATH=$(command -v hyprpolkitagent)

# Starts the Hyprland polkit agent
"$HYPRPOLKITAGENT_PATH" &
if [ $? -eq 0 ]; then
    notify-send -u low -i "$iDIR/ja.png" "Polkit Agent" "Hyprland Polkit agent started."
else
    notify-send -i "$iDIR/error.png" "Error: Polkit Agent" "Failed to start Hyprland Polkit agent."
fi
