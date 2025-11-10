#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# wlogout (Power, Screen Lock, Suspend, etc)

# Set variables for parameters. First numbers corresponts to Monitor Resolution
# i.e 2160 means 2160p
A_2160=600
B_2160=600
A_1600=400
B_1600=400
A_1440=400
B_1440=400
A_1080=200
B_1080=200
A_720=50
B_720=50

# Directory for swaync images (for notify-send)
iDIR="$HOME/.config/swaync/images"

# --- Dependency Check ---
check_dependency() {
    command -v "$1" >/dev/null 2>&1 || { notify-send -i "$iDIR/error.png" "Error: Missing Dependency" "$1 is not installed. Aborting."; exit 1; }
}

check_dependency "wlogout"
check_dependency "hyprctl"
check_dependency "jq"
check_dependency "awk"
check_dependency "pgrep"
check_dependency "pkill"
check_dependency "notify-send"

# Check if wlogout is already running
if pgrep -x "wlogout" > /dev/null; then
    pkill -x "wlogout"
    exit 0
fi

# Detect monitor resolution and scaling factor
resolution=$(hyprctl -j monitors | jq -r '.[] | select(.focused==true) | .height / .scale' 2>/dev/null | awk -F'.' '{print $1}')
hypr_scale=$(hyprctl -j monitors | jq -r '.[] | select(.focused==true) | .scale' 2>/dev/null)

if [[ -z "$resolution" || -z "$hypr_scale" ]]; then
    notify-send -i "$iDIR/error.png" "Error: Monitor Detection" "Failed to detect monitor resolution or scaling. Launching wlogout with default parameters."
    wlogout &
    exit 1
fi

# Set parameters based on screen resolution and scaling factor
if ((resolution >= 2160)); then
    T_val=$(awk "BEGIN {printf \"%.0f\", $A_2160 * 2160 * $hypr_scale / $resolution}")
    B_val=$(awk "BEGIN {printf \"%.0f\", $B_2160 * 2160 * $hypr_scale / $resolution}")
    wlogout --protocol layer-shell -b 6 -T "$T_val" -B "$B_val" & || notify-send -i "$iDIR/error.png" "Error" "Failed to launch wlogout."
elif ((resolution >= 1600 && resolution < 2160)); then
    T_val=$(awk "BEGIN {printf \"%.0f\", $A_1600 * 1600 * $hypr_scale / $resolution}")
    B_val=$(awk "BEGIN {printf \"%.0f\", $B_1600 * 1600 * $hypr_scale / $resolution}")
    wlogout --protocol layer-shell -b 6 -T "$T_val" -B "$B_val" & || notify-send -i "$iDIR/error.png" "Error" "Failed to launch wlogout."
elif ((resolution >= 1440 && resolution < 1600)); then
    T_val=$(awk "BEGIN {printf \"%.0f\", $A_1440 * 1440 * $hypr_scale / $resolution}")
    B_val=$(awk "BEGIN {printf \"%.0f\", $B_1440 * 1440 * $hypr_scale / $resolution}")
    wlogout --protocol layer-shell -b 6 -T "$T_val" -B "$B_val" & || notify-send -i "$iDIR/error.png" "Error" "Failed to launch wlogout."
elif ((resolution >= 1080 && resolution < 1440)); then
    T_val=$(awk "BEGIN {printf \"%.0f\", $A_1080 * 1080 * $hypr_scale / $resolution}")
    B_val=$(awk "BEGIN {printf \"%.0f\", $B_1080 * 1080 * $hypr_scale / $resolution}")
    wlogout --protocol layer-shell -b 6 -T "$T_val" -B "$B_val" & || notify-send -i "$iDIR/error.png" "Error" "Failed to launch wlogout."
elif ((resolution >= 720 && resolution < 1080)); then
    T_val=$(awk "BEGIN {printf \"%.0f\", $A_720 * 720 * $hypr_scale / $resolution}")
    B_val=$(awk "BEGIN {printf \"%.0f\", $B_720 * 720 * $hypr_scale / $resolution}")
    wlogout --protocol layer-shell -b 3 -T "$T_val" -B "$B_val" & || notify-send -i "$iDIR/error.png" "Error" "Failed to launch wlogout."
else
    notify-send -i "$iDIR/note.png" "Wlogout" "Launching wlogout with default parameters."
    wlogout & || notify-send -i "$iDIR/error.png" "Error" "Failed to launch wlogout."
fi
