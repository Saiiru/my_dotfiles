#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  #
# Overview toggle wrapper - tries Quickshell first, falls back to AGS

set -euo pipefail

# Directory for swaync images (for notify-send)
iDIR="$HOME/.config/swaync/images"

# --- Dependency Check ---
check_dependency() {
    command -v "$1" >/dev/null 2>&1 || { notify-send -i "$iDIR/error.png" "Error: Missing Dependency" "$1 is not installed. Aborting."; exit 1; }
}

check_dependency "hyprctl"
check_dependency "notify-send"
# qs is checked inline below if hyprctl dispatch fails

# 1) Try Quickshell via Hyprland global dispatch (works if QS is running and listening)
if hyprctl dispatch global quickshell:overviewToggle >/dev/null 2>&1; then
  exit 0
fi

# If QS isn't running, try starting it and retry once
if command -v qs >/dev/null 2>&1; then
  notify-send -i "$iDIR/ja.png" "Quickshell" "Starting Quickshell..." -u low
  qs >/dev/null 2>&1 &
  sleep 0.6
  if hyprctl dispatch global quickshell:overviewToggle >/dev/null 2>&1; then
    exit 0
  fi
fi

# If we get here, neither worked
notify-send -i "$iDIR/error.png" "Overview Error" "Quickshell is not available." -u critical || true
exit 1
