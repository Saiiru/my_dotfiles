#!/usr/bin/env bash
set -euo pipefail
log() { printf "[autostart] %s\n" "$*"; }
start() {
    local cmd="$1"; shift
    if pgrep -f "$cmd" >/dev/null 2>&1; then
        return
    fi
    ("$@" >/dev/null 2>&1 &) &
}

# Prepare session environment for portals/flatpak
systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP || true
dbus-update-activation-environment --systemd WAYLAND_DISPLAY DISPLAY XDG_CURRENT_DESKTOP >/dev/null 2>&1 || true

start wl-paste wl-paste --type text --watch cliphist store
start wl-paste wl-paste --type image --watch cliphist store
start cliphist cliphist daemon
start waybar waybar
start dunst dunst
start swaybg swaybg -m fill -i "$HOME/wallpapers/current.png"
start nm-applet nm-applet --indicator
start polkit /usr/lib/mate-polkit/polkit-mate-authentication-agent-1
start kanshi kanshi
start gammastep gammastep -O 4500
start syncthing syncthing serve --no-browser
