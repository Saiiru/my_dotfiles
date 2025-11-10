#!/usr/bin/env bash
# Red Hood screenshot orchestrator
set -euo pipefail

require() {
  command -v "$1" >/dev/null 2>&1 || { echo "Missing dependency: $1" >&2; exit 1; }
}

require grim
require wl-copy
require notify-send
require jq

SLURP_AVAILABLE=1
command -v slurp >/dev/null 2>&1 || SLURP_AVAILABLE=0
SWAPPY_AVAILABLE=1
command -v swappy >/dev/null 2>&1 || SWAPPY_AVAILABLE=0

now_ts=$(date '+%d-%b_%H-%M-%S')
shots_dir="$(xdg-user-dir PICTURES 2>/dev/null || printf '%s/Pictures' "$HOME")/Screenshots"
mkdir -p "$shots_dir"

base_file="Screenshot_${now_ts}_${RANDOM}.png"
base_path="${shots_dir}/${base_file}"

icons_dir="$HOME/.config/swaync/icons"
images_dir="$HOME/.config/swaync/images"
picture_icon="${icons_dir}/picture.png"
note_icon="${images_dir}/note.png"
timer_icon="${icons_dir}/timer.png"
[[ -f "$picture_icon" ]] || picture_icon=dialog-information
[[ -f "$note_icon" ]] || note_icon=dialog-information
[[ -f "$timer_icon" ]] || timer_icon=appointment-soon

scripts_dir="$HOME/.config/hypr/scripts"
sounds_script="${scripts_dir}/Sounds.sh"
play_sound() {
  [[ -x "$sounds_script" ]] && "$sounds_script" "--$1"
}

notify_cmd_base=(notify-send -t 8000 -A action1=Open -A action2=Delete -h string:x-canonical-private-synchronous:shot-notify)
notify_file() {
  local path="$1" message="$2"
  if [[ -e "$path" ]]; then
    play_sound screenshot
    response=$(timeout 5 "${notify_cmd_base[@]}" -i "$picture_icon" "Screenshot" "$message")
    case "$response" in
      action1) xdg-open "$path" & ;;
      action2) rm "$path" & ;;
    esac
  else
    notify-send -u low -i "$note_icon" "Screenshot" "Not saved"
    play_sound error
  fi
}

countdown() {
  local secs="$1"
  for sec in $(seq "$secs" -1 1); do
    notify-send -h string:x-canonical-private-synchronous:shot-notify -t 900 -i "$timer_icon" "Taking shot" "in: $sec s"
    sleep 1
  done
}

shot_now() {
  cd "$shots_dir"
  grim - | tee "$base_file" | wl-copy
  sleep 1
  notify_file "$base_path" "Saved to clipboard"
}

shot_delayed() {
  local secs="$1"
  countdown "$secs"
  sleep 1
  cd "$shots_dir"
  grim - | tee "$base_file" | wl-copy
  sleep 1
  notify_file "$base_path" "Saved after ${secs}s"
}

shot_area() {
  if [[ "$SLURP_AVAILABLE" -eq 0 ]]; then
    echo "slurp not available" >&2
    exit 1
  fi
  tmpfile=$(mktemp)
  grim -g "$(slurp)" - >"$tmpfile"
  if [[ -s "$tmpfile" ]]; then
    wl-copy <"$tmpfile"
    mv "$tmpfile" "$base_path"
    notify_file "$base_path" "Area saved"
  else
    rm -f "$tmpfile"
  fi
}

shot_active_window() {
  local active_json
  active_json=$(hyprctl -j activewindow)
  local win_class
  win_class=$(printf '%s' "$active_json" | jq -r '.class // "window"')
  local coords size
  coords=$(printf '%s' "$active_json" | jq -r '"\(.at[0]),\(.at[1])"')
  size=$(printf '%s' "$active_json" | jq -r '"\(.size[0])x\(.size[1])"')
  local file_path="${shots_dir}/Screenshot_${now_ts}_${win_class}.png"
  grim -g "$coords $size" "$file_path"
  notify_file "$file_path" "${win_class}"
}

shot_window_manual() {
  local w_pos w_size
  w_pos=$(hyprctl activewindow | awk '/at:/ {print $2}' | tail -n1 | tr -d ' ')
  w_size=$(hyprctl activewindow | awk '/size:/ {print $2}' | tail -n1 | tr -d ' ' | sed 's/,/x/')
  cd "$shots_dir"
  grim -g "$w_pos $w_size" - | tee "$base_file" | wl-copy
  notify_file "$base_path" "Active window"
}

shot_swappy() {
  if [[ "$SLURP_AVAILABLE" -eq 0 || "$SWAPPY_AVAILABLE" -eq 0 ]]; then
    echo "slurp/swappy not available" >&2
    exit 1
  fi
  tmpfile=$(mktemp)
  grim -g "$(slurp)" - >"$tmpfile"
  if [[ -s "$tmpfile" ]]; then
    wl-copy <"$tmpfile"
    play_sound screenshot
    response=$("${notify_cmd_base[@]}" -i "$picture_icon" "Screenshot" "Captured (Swappy)")
    case "$response" in
      action1) swappy -f - <"$tmpfile" ;;
      action2) rm "$tmpfile" ;;
    esac
  else
    rm -f "$tmpfile"
  fi
}

case "${1:-}" in
  --now) shot_now ;;
  --in5) shot_delayed 5 ;;
  --in10) shot_delayed 10 ;;
  --win) shot_window_manual ;;
  --area) shot_area ;;
  --active) shot_active_window ;;
  --swappy) shot_swappy ;;
  *)
    cat <<USAGE
Usage: ${0##*/} [--now|--in5|--in10|--win|--area|--active|--swappy]
USAGE
    exit 1
    ;;
esac
