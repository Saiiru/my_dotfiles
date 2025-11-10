##################################################################
#                                                                #   
#                                                                #
#                  TAK_0'S Per-Window-Switch                     #
#                                                                #
#                                                                #
#                                                                #
#  Just a little script that I made to switch keyboard layouts   #
#       per-window instead of global switching for the more      #
#                 smooth and comfortable workflow.               #  
#                                                                #
##################################################################

# This is for changing kb_layouts. Set kb_layouts in 

MAP_FILE="$HOME/.cache/kb_layout_per_window"
CFG_FILE="$HOME/.config/hypr/UserConfigs/UserSettings.conf"
ICON="$HOME/.config/swaync/images/ja.png" # Assuming this is the correct path for a generic icon
SCRIPT_NAME="$(basename "$0")"

# --- Dependency Check ---
check_dependency() {
    command -v "$1" >/dev/null 2>&1 || { notify-send -i "$ICON" "Error: Missing Dependency" "$1 is not installed. Aborting."; exit 1; }
}

check_dependency "hyprctl"
check_dependency "jq"
check_dependency "grep"
check_dependency "cut"
check_dependency "tr"
check_dependency "sed"
check_dependency "touch"
check_dependency "mktemp"
check_dependency "mv"
check_dependency "socat"
check_dependency "pgrep"
check_dependency "notify-send"

# Ensure map file exists
touch "$MAP_FILE"

# Read layouts from config
if ! grep -q 'kb_layout' "$CFG_FILE"; then
  notify-send -i "$ICON" "Error: Config" "Cannot find kb_layout in $CFG_FILE"
  exit 1
fi
kb_layouts=($(grep 'kb_layout' "$CFG_FILE" | cut -d '=' -f2 | tr -d '[:space:]' | tr ',' ' '))
count=${#kb_layouts[@]}

# Get current active window ID
get_win() {
  hyprctl activewindow -j | jq -r '.address // .id'
}

# Get available keyboards
get_keyboards() {
  hyprctl devices -j | jq -r '.keyboards[].name'
}

# Save window-specific layout
save_map() {
  local W=$1 L=$2
  grep -v "^${W}:" "$MAP_FILE" > "$MAP_FILE.tmp"
  echo "${W}:${L}" >> "$MAP_FILE.tmp"
  mv "$MAP_FILE.tmp" "$MAP_FILE"
}

# Load layout for window (fallback to default)
load_map() {
  local W=$1
  local E
  E=$(grep "^${W}:" "$MAP_FILE")
  [[ -n "$E" ]] && echo "${E#*:}" || echo "${kb_layouts[0]}"
}

# Switch layout for all keyboards to layout index
do_switch() {
  local IDX=$1
  for kb in $(get_keyboards); do
    hyprctl switchxkblayout "$kb" "$IDX" 2>/dev/null || notify-send -i "$ICON" "Error: Hyprctl" "Failed to switch keyboard layout for $kb"
  done
}

# Toggle layout for current window only
cmd_toggle() {
  local W=$(get_win)
  [[ -z "$W" ]] && { notify-send -i "$ICON" "Error: Window" "No active window found."; return; }
  local CUR=$(load_map "$W")
  local i NEXT
  for idx in "${!kb_layouts[@]}"; do
    if [[ "${kb_layouts[idx]}" == "$CUR" ]]; then
      i=$idx
      break
    fi
  done
  NEXT=$(( (i+1) % count ))
  do_switch "$NEXT"
  save_map "$W" "${kb_layouts[NEXT]}"
  notify-send -u low -i "$ICON" "Keyboard Layout" "Switched to: ${kb_layouts[NEXT]}"
}

# Restore layout on focus
cmd_restore() {
  local W=$(get_win)
  [[ -z "$W" ]] && return
  local LAY=$(load_map "$W")
  for idx in "${!kb_layouts[@]}"; do
    if [[ "${kb_layouts[idx]}" == "$LAY" ]]; then
      do_switch "$idx"
      break
    fi
  done
}

# Listen to focus events and restore window-specific layouts
subscribe() {
  local SOCKET2="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"
  [[ -S "$SOCKET2" ]] || { notify-send -i "$ICON" "Error: Hyprland Socket" "Hyprland socket not found. Is Hyprland running?"; exit 1; }

  socat -u UNIX-CONNECT:"$SOCKET2" - | while read -r line; do
    [[ "$line" =~ ^activewindow ]] && cmd_restore
  done
}

# Ensure only one listener
if ! pgrep -f "$SCRIPT_NAME.*--listener" >/dev/null; then
  subscribe --listener &
fi

# CLI
case "$1" in
  toggle|"") cmd_toggle ;;
  *) notify-send -i "$ICON" "Usage Error" "Usage: $SCRIPT_NAME [toggle]"; exit 1 ;;
esac
