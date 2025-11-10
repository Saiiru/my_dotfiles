#!/usr/bin/env bash
# Script parses /proc/uptime to get the system uptime
# and prints it in a human-readable format
# This is a workaround for system where `uptime` command is taken from coreutils
# where `uptime -p` is not supported

iDIR="$HOME/.config/swaync/images" # For notify-send icons

# --- Dependency Check ---
check_dependency() {
    command -v "$1" >/dev/null 2>&1 || { echo >&2 "Error: Missing Dependency: $1. Aborting."; exit 1; }
}

check_dependency "notify-send"

if [[ -r /proc/uptime ]]; then
    s=$(< /proc/uptime)
    s=${s/.*}
else
    notify-send -i "$iDIR/error.png" "Uptime Error" "Uptime could not be determined from /proc/uptime."
    echo "Error UptimeNixOS.sh: Uptime could not be determined." >&2
    exit 1
fi

d="$((s / 60 / 60 / 24)) days"
h="$((s / 60 / 60 % 24)) hours"
m="$((s / 60 % 60)) minutes"

# Remove plural if < 2.
((${d/ *} == 1)) && d=${d/s}
((${h/ *} == 1)) && h=${h/s}
((${m/ *} == 1)) && m=${m/s}

# Hide empty fields.
((${d/ *} == 0)) && unset d
((${h/ *} == 0)) && unset h
((${m/ *} == 0)) && unset m

uptime=${d:+$d, }${h:+$h, }$m
uptime=${uptime%', '}
uptime=${uptime:-$s seconds}

echo "up $uptime"
