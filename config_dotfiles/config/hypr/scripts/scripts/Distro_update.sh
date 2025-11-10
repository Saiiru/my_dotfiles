#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Simple bash script to check and will try to update your system

# Local Paths
iDIR="$HOME/.config/swaync/images"

# --- Dependency Check ---
check_dependency() {
    command -v "$1" >/dev/null 2>&1 || { notify-send -i "$iDIR/error.png" "Error: Missing Dependency" "$1 is not installed. Aborting."; exit 1; }
}

check_dependency "kitty"
check_dependency "notify-send"

update_successful=true

# Detect distribution and update accordingly
if command -v paru &> /dev/null; then
  # Arch-based with paru
  kitty -T "System Update" paru -Syu --noconfirm
  if [ $? -ne 0 ]; then update_successful=false; fi
elif command -v yay &> /dev/null; then
  # Arch-based with yay
  kitty -T "System Update" yay -Syu --noconfirm
  if [ $? -ne 0 ]; then update_successful=false; fi
elif command -v dnf &> /dev/null; then
  # Fedora-based
  kitty -T "System Update" sudo dnf update --refresh -y
  if [ $? -ne 0 ]; then update_successful=false; fi
elif command -v apt &> /dev/null; then
  # Debian-based (Debian, Ubuntu, etc.)
  kitty -T "System Update" sudo apt update && sudo apt upgrade -y
  if [ $? -ne 0 ]; then update_successful=false; fi
elif command -v zypper &> /dev/null; then
  # openSUSE-based
  kitty -T "System Update" sudo zypper dup -y
  if [ $? -ne 0 ]; then update_successful=false; fi
else
  # Unsupported distro
  notify-send -i "$iDIR/error.png" -u critical "Unsupported system" "This script does not support your distribution."
  exit 1
fi

# Flatpak update
if command -v flatpak &> /dev/null; then
  kitty -T "Flatpak Update" flatpak update --noninteractive
  if [ $? -ne 0 ]; then update_successful=false; fi
fi

if $update_successful; then
  notify-send -i "$iDIR/ja.png" -u low 'System Update' 'All packages have been updated successfully.'
else
  notify-send -i "$iDIR/error.png" -u critical 'System Update' 'Some updates failed. Check the terminal for details.'
fi
