#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# This script starts the first available Polkit agent from a list of possible locations

iDIR="$HOME/.config/swaync/images" # For notify-send icons

# --- Dependency Check ---
check_dependency() {
    command -v "$1" >/dev/null 2>&1 || { echo >&2 "Error: Missing Dependency: $1. Aborting."; exit 1; }
}

check_dependency "notify-send"

# List of potential Polkit agent file paths
polkit=(
  "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"
  "/usr/libexec/hyprpolkitagent"
  "/usr/lib/hyprpolkitagent"
  "/usr/lib/hyprpolkitagent/hyprpolkitagent"
  "/usr/lib/polkit-kde-authentication-agent-1"
  "/usr/lib/polkit-gnome-authentication-agent-1"
  "/usr/libexec/polkit-gnome-authentication-agent-1"
  "/usr/libexec/polkit-mate-authentication-agent-1"
  "/usr/lib/x86_64-linux-gnu/libexec/polkit-kde-authentication-agent-1"
  "/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1"
)

executed=false

# Loop through the list of paths
for file in "${polkit[@]}"; do
  if [ -e "$file" ] && [ ! -d "$file" ]; then
    exec "$file"
    executed=true
    break
  fi
done

# Fallback message if nothing executed
if [ "$executed" == false ]; then
  notify-send -i "$iDIR/error.png" "Polkit Agent" "No valid Polkit agent found. Please install one."
fi
