#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# For applying Pre-configured Monitor Profiles

# Variables
iDIR="$HOME/.config/swaync/images"
SCRIPTSDIR="$HOME/.config/hypr/scripts"
monitor_dir="$HOME/.config/hypr/Monitor_Profiles"
target="$HOME/.config/hypr/monitors.conf"
rofi_theme="$HOME/.config/rofi/config-Monitors.rasi"
msg='❗NOTE:❗ This will overwrite $HOME/.config/hypr/monitors.conf'

# --- Dependency Check ---
check_dependency() {
    command -v "$1" >/dev/null 2>&1 || { notify-send -i "$iDIR/error.png" "Error: Missing Dependency" "$1 is not installed. Aborting."; exit 1; }
}

check_dependency "rofi"
check_dependency "find"
check_dependency "sed"
check_dependency "sort"
check_dependency "cp"
check_dependency "notify-send"
check_dependency "pidof"
check_dependency "$SCRIPTSDIR/RefreshNoWaybar.sh"

# Check if rofi is already running
if pidof rofi > /dev/null; then
  pkill rofi
fi

# Define the list of files to ignore
ignore_files=(
  "README"
)

# Check if monitor profiles directory exists and contains files
if [[ ! -d "$monitor_dir" ]]; then
    notify-send -i "$iDIR/error.png" "Error: Directory Not Found" "Monitor profiles directory not found: $monitor_dir. Aborting."
    exit 1
fi

# list of Monitor Profiles, sorted alphabetically with numbers first
mon_profiles_list=$(find -L "$monitor_dir" -maxdepth 1 -type f -name "*.conf" | sed 's/.*\///' | sed 's/\.conf$//' | sort -V)

if [[ -z "$mon_profiles_list" ]]; then
    notify-send -i "$iDIR/error.png" "Error: No Profiles" "No monitor .conf files found in $monitor_dir. Aborting."
    exit 1
fi

# Remove ignored files from the list
for ignored_file in "${ignore_files[@]}"; do
    mon_profiles_list=$(echo "$mon_profiles_list" | grep -v -E "^$ignored_file$")
done

# Rofi Menu
chosen_file=$(echo "$mon_profiles_list" | rofi -i -dmenu -config "$rofi_theme" -mesg "$msg")

if [[ -n "$chosen_file" ]]; then
    full_path="$monitor_dir/$chosen_file.conf"
    cp "$full_path" "$target" && notify-send -u low -i "$iDIR/ja.png" "$chosen_file" "Monitor Profile Loaded" || notify-send -i "$iDIR/error.png" "Error" "Failed to copy monitor profile."
fi

sleep 1
"${SCRIPTSDIR}/RefreshNoWaybar.sh" &