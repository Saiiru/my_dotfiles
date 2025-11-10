#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Game Mode. Turning off all animations

notif="$HOME/.config/swaync/images/ja.png"
SCRIPTSDIR="$HOME/.config/hypr/scripts"

# --- Dependency Check ---
check_dependency() {
    command -v "$1" >/dev/null 2>&1 || { notify-send -i "$notif" "Error: Missing Dependency" "$1 is not installed. Aborting."; exit 1; }
}

check_dependency "hyprctl"
check_dependency "awk"
check_dependency "swww"
check_dependency "notify-send"
check_dependency "$SCRIPTSDIR/WallustSwww.sh"
check_dependency "$SCRIPTSDIR/Refresh.sh"

HYPRGAMEMODE=$(hyprctl getoption animations:enabled | awk 'NR==1{print $2}')
if [ "$HYPRGAMEMODE" = 1 ] ; then
    hyprctl --batch "\
        keyword animations:enabled 0;\
        keyword decoration:shadow:enabled 0;\
        keyword decoration:blur:enabled 0;\
        keyword general:gaps_in 0;\
        keyword general:gaps_out 0;\
        keyword general:border_size 1;\
        keyword decoration:rounding 0"
	
	hyprctl keyword "windowrule opacity 1 override 1 override 1 override, ^(.*)$"
    swww kill 
    notify-send -e -u low -i "$notif" " Gamemode:" " enabled"
    exit
else
	swww-daemon --format xrgb && swww img "$HOME/.config/rofi/.current_wallpaper" &
	sleep 0.1
	"${SCRIPTSDIR}/WallustSwww.sh"
	sleep 0.5
  hyprctl reload
	"${SCRIPTSDIR}/Refresh.sh"	 
    notify-send -e -u normal -i "$notif" " Gamemode:" " disabled"
    exit
fi
