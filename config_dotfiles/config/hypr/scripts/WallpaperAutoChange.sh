#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# source https://wiki.archlinux.org/title/Hyprland#Using_a_script_to_change_wallpaper_every_X_minutes

# This script will randomly go through the files of a directory, setting it
# up as the wallpaper at regular intervals
#
# NOTE: this script uses bash (not POSIX shell) for the RANDOM variable

# --- Dependency Check ---
check_dependency() {
    command -v "$1" >/dev/null 2>&1 || { echo >&2 "Error: $1 is not installed. Aborting."; exit 1; }
}

check_dependency "swww"
check_dependency "hyprctl"
check_dependency "awk"
check_dependency "find"
check_dependency "sort"
check_dependency "cut"

wallust_refresh="$(dirname "$0")/RefreshNoWaybar.sh"

focused_monitor=$(hyprctl monitors | awk '/^Monitor/{name=$2} /focused: yes/{print name}')

if [[ -z "$focused_monitor" ]]; then
  echo "Error: Could not detect focused monitor. Aborting." >&2
  exit 1
fi

if [[ $# -lt 1 ]] || [[ ! -d $1   ]]; then
	echo "Usage:
	$0 <dir containing images>"
	exit 1
fi

# Edit below to control the images transition
export SWWW_TRANSITION_FPS=60
export SWWW_TRANSITION_TYPE=simple

# This controls (in seconds) when to switch to the next image
INTERVAL=1800

while true; do
	find "$1" \
		| while read -r img; do
			echo "$((RANDOM % 1000)):$img"
		done \
		| sort -n | cut -d':' -f2- \
		| while read -r img; do
			swww img -o $focused_monitor "$img"
			# Regenerate colors from the exact image path to avoid cache races
			$HOME/.config/hypr/scripts/WallustSwww.sh "$img"
			# Refresh UI components that depend on wallust output
			$wallust_refresh
			sleep $INTERVAL
			
		done
done
