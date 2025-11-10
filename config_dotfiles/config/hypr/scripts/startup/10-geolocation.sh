#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Starts geolocation and gamma adjustment services

iDIR="$HOME/.config/swaync/images" # For notify-send icons

# --- Dependency Check ---
check_dependency() {
    command -v "$1" >/dev/null 2>&1 || { notify-send -i "$iDIR/error.png" "Error: Missing Dependency" "$1 is not installed. Aborting."; exit 1; }
}

check_dependency "notify-send"
check_dependency "gammastep"

# Find the geoclue-agent executable
GEOCLUE_AGENT_PATH=$(command -v geoclue-agent) # Try generic name first
if [[ -z "$GEOCLUE_AGENT_PATH" ]]; then
    # Fallback to specific path if generic not found
    if [[ -x "/usr/lib/geoclue-2.0/demos/agent" ]]; then
        GEOCLUE_AGENT_PATH="/usr/lib/geoclue-2.0/demos/agent"
    fi
fi

if [[ -z "$GEOCLUE_AGENT_PATH" ]]; then
    notify-send -i "$iDIR/error.png" "Error: Geolocation" "geoclue-agent not found. Geolocation services will not start."
else
    "$GEOCLUE_AGENT_PATH" &
    if [ $? -eq 0 ]; then
        notify-send -u low -i "$iDIR/ja.png" "Geolocation" "Geoclue agent started."
    else
        notify-send -i "$iDIR/error.png" "Error: Geolocation" "Failed to start Geoclue agent."
    fi
fi

gammastep &
if [ $? -eq 0 ]; then
    notify-send -u low -i "$iDIR/ja.png" "Gammastep" "Gammastep started."
else
    notify-send -i "$iDIR/error.png" "Error: Gammastep" "Failed to start Gammastep."
fi
