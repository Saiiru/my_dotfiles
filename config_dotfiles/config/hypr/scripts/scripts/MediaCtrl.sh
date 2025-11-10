#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Playerctl

music_icon="$HOME/.config/swaync/icons/music.png"

# --- Dependency Check ---
check_dependency() {
    command -v "$1" >/dev/null 2>&1 || { notify-send -i "$music_icon" "Error: Missing Dependency" "$1 is not installed. Aborting."; exit 1; }
}

check_dependency "playerctl"
check_dependency "notify-send"

# Play the next track
play_next() {
  playerctl next || notify-send -i "$music_icon" "Error" "Failed to play next track."
  show_music_notification
}

# Play the previous track
play_previous() {
  playerctl previous || notify-send -i "$music_icon" "Error" "Failed to play previous track."
  show_music_notification
}

# Toggle play/pause
toggle_play_pause() {
  playerctl play-pause || notify-send -i "$music_icon" "Error" "Failed to toggle play/pause."
  sleep 0.1
  show_music_notification
}

# Stop playback
stop_playback() {
  playerctl stop || notify-send -i "$music_icon" "Error" "Failed to stop playback."
  notify-send -e -u low -i "$music_icon" " Playback:" " Stopped"
}

# Display notification with song information
show_music_notification() {
  local status=$(playerctl status 2>/dev/null)
  if [[ -z "$status" ]]; then
    notify-send -e -u low -i "$music_icon" "Player" "No media player running."
    return
  fi

  if [[ "$status" == "Playing" ]]; then
    local song_title=$(playerctl metadata title 2>/dev/null)
    local song_artist=$(playerctl metadata artist 2>/dev/null)
    song_title=${song_title:-"Unknown Title"}
    song_artist=${song_artist:-"Unknown Artist"}
    notify-send -e -u low -i "$music_icon" "Now Playing:" "$song_title by $song_artist"
  elif [[ "$status" == "Paused" ]]; then
    notify-send -e -u low -i "$music_icon" " Playback:" " Paused"
  fi
}

# Get media control action from command line argument
case "$1" in
"--nxt")
  play_next
  ;;
"--prv")
  play_previous
  ;;
"--pause")
  toggle_play_pause
  ;;
"--stop")
  stop_playback
  ;;
*)
  notify-send -i "$music_icon" "Usage Error" "Usage: $0 [--nxt|--prv|--pause|--stop]"
  exit 1
  ;;
esac
