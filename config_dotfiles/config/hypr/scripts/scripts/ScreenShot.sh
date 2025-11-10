#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Screenshots scripts

# variables
time=$(date "+%d-%b_%H-%M-%S")
dir="$(xdg-user-dir PICTURES)/Screenshots"
file="Screenshot_${time}_${RANDOM}.png"

iDIR="$HOME/.config/swaync/icons"
iDoR="$HOME/.config/swaync/images"
sDIR="$HOME/.config/hypr/scripts"

# --- Dependency Check ---
check_dependency() {
    command -v "$1" >/dev/null 2>&1 || { notify-send -i "$iDIR/error.png" "Error: Missing Dependency" "$1 is not installed. Aborting."; exit 1; }
}

check_dependency "grim"
check_dependency "slurp"
check_dependency "swappy"
check_dependency "wl-copy"
check_dependency "hyprctl"
check_dependency "jq"
check_dependency "notify-send"
check_dependency "mktemp"
check_dependency "xdg-open"
check_dependency "rm"
check_dependency "$sDIR/Sounds.sh"

active_window_class=$(hyprctl -j activewindow | jq -r '(.class)')
active_window_file="Screenshot_${time}_${active_window_class}.png"
active_window_path="${dir}/${active_window_file}"

notify_cmd_base="notify-send -t 10000 -A action1=Open -A action2=Delete -h string:x-canonical-private-synchronous:shot-notify"
notify_cmd_shot="${notify_cmd_base} -i ${iDIR}/picture.png "
notify_cmd_shot_win="${notify_cmd_base} -i ${iDIR}/picture.png "
notify_cmd_NOT="notify-send -u low -i ${iDoR}/note.png "

# notify and view screenshot
notify_view() {
    if [[ "$1" == "active" ]]; then
        if [[ -e "${active_window_path}" ]]; then
			"${sDIR}/Sounds.sh" --screenshot        
            resp=$(timeout 5 ${notify_cmd_shot_win} " Screenshot of:" " ${active_window_class} Saved.")
            case "$resp" in
				action1)
					xdg-open "${active_window_path}" &
					;;
				action2)
					rm "${active_window_path}" &
					;;
			esac
        else
            ${notify_cmd_NOT} " Screenshot of:" " ${active_window_class} NOT Saved."
            "${sDIR}/Sounds.sh" --error
        fi

    elif [[ "$1" == "swappy" ]]; then
		"${sDIR}/Sounds.sh" --screenshot
		resp=$(${notify_cmd_shot} " Screenshot:" " Captured by Swappy")
		case "$resp" in
			action1)
				swappy -f - <"$tmpfile" || notify-send -i "$iDIR/error.png" "Error" "Failed to open swappy."
				;;
			action2)
				rm "$tmpfile"
				;;
		esac

    else
        local check_file="${dir}/${file}"
        if [[ -e "$check_file" ]]; then
            "${sDIR}/Sounds.sh" --screenshot
            resp=$(timeout 5 ${notify_cmd_shot} " Screenshot" " Saved")
			case "$resp" in
				action1)
					xdg-open "${check_file}" &
					;;
				action2)
					rm "${check_file}" &
					;;
			esac
        else
            ${notify_cmd_NOT} " Screenshot" " NOT Saved"
            "${sDIR}/Sounds.sh" --error
        fi
    fi
}

# countdown
countdown() {
	for sec in $(seq "$1" -1 1); do
		notify-send -h string:x-canonical-private-synchronous:shot-notify -t 1000 -i "$iDIR"/timer.png  " Taking shot" " in: $sec secs"
		sleep 1
	done
}

# take shots
shotnow() {
	cd "${dir}" && grim - | tee "$file" | wl-copy || notify-send -i "$iDIR/error.png" "Error" "Failed to take screenshot."
	sleep 2
	notify_view
}

shot5() {
	countdown '5'
	sleep 1 && cd "${dir}" && grim - | tee "$file" | wl-copy || notify-send -i "$iDIR/error.png" "Error" "Failed to take screenshot."
	sleep 1
	notify_view
}

shot10() {
	countdown '10'
	sleep 1 && cd "${dir}" && grim - | tee "$file" | wl-copy || notify-send -i "$iDIR/error.png" "Error" "Failed to take screenshot."
	notify_view
}

shotwin() {
    # Use the more robust method from shotactive
    hyprctl -j activewindow | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"' | grim -g - "${dir}/${file}" | wl-copy || notify-send -i "$iDIR/error.png" "Error" "Failed to take active window screenshot."
    notify_view
}

shotarea() {
	tmpfile=$(mktemp)
	grim -g "$(slurp)" - >"$tmpfile" || { notify-send -i "$iDIR/error.png" "Error" "Failed to select area or take screenshot."; rm "$tmpfile"; return 1; }

  # Copy with saving
	if [[ -s "$tmpfile" ]]; then
		wl-copy <"$tmpfile" || notify-send -i "$iDIR/error.png" "Error" "Failed to copy to clipboard."
		mv "$tmpfile" "$dir/$file" || notify-send -i "$iDIR/error.png" "Error" "Failed to save screenshot."
	fi
	notify_view
}

shotactive() {
    active_window_class=$(hyprctl -j activewindow | jq -r '(.class)')
    active_window_file="Screenshot_${time}_${active_window_class}.png"
    active_window_path="${dir}/${active_window_file}"

    hyprctl -j activewindow | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"' | grim -g - "${active_window_path}" || notify-send -i "$iDIR/error.png" "Error" "Failed to take active window screenshot."
	sleep 1
    notify_view "active"
}

shotswappy() {
	tmpfile=$(mktemp)
	grim -g "$(slurp)" - >"$tmpfile" || { notify-send -i "$iDIR/error.png" "Error" "Failed to select area or take screenshot."; rm "$tmpfile"; return 1; }

  # Copy without saving
  if [[ -s "$tmpfile" ]]; then
		wl-copy <"$tmpfile" || notify-send -i "$iDIR/error.png" "Error" "Failed to copy to clipboard."
    notify_view "swappy"
  fi
}

if [[ ! -d "$dir" ]]; then
	mkdir -p "$dir" || { notify-send -i "$iDIR/error.png" "Error" "Failed to create screenshot directory: $dir"; exit 1; }
fi

if [[ "$1" == "--now" ]]; then
	shotnow
elif [[ "$1" == "--in5" ]]; then
	shot5
elif [[ "$1" == "--in10" ]]; then
	shot10
elif [[ "$1" == "--win" ]]; then
	shotwin
elif [[ "$1" == "--area" ]]; then
	shotarea
elif [[ "$1" == "--active" ]]; then
	shotactive
elif [[ "$1" == "--swappy" ]]; then
	shotswappy
else
	echo -e "Available Options : --now --in5 --in10 --win --area --active --swappy"
fi

exit 0
