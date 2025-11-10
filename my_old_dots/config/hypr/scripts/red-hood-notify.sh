#!/usr/bin/env bash
# Unified notify-send wrapper for Red Hood theme

set -euo pipefail

TYPE="${1:-info}"
MESSAGE="${2:-}"

send() {
    local summary="$1"
    local body="$2"
    local urgency="${3:-low}"
    notify-send --urgency="$urgency" --expire-time=2500 "$summary" "$body"
}

case "$TYPE" in
    welcome)
        send "🔥 Red Hood Online" "${MESSAGE:-Systems armed}" normal
        ;;
    border)
        send "🌈 Borders" "${MESSAGE:-Scheme applied}" low
        ;;
    effect)
        send "⚡ Effect" "${MESSAGE:-Pulse toggled}" low
        ;;
    wallpaper)
        send "🎨 Wallpaper" "${MESSAGE:-Palette synced}" low
        ;;
    color)
        send "🌈 Palette" "${MESSAGE:-Colors extracted}" low
        ;;
    volume)
        send "🔊 Volume" "${MESSAGE:-Level updated}" low
        ;;
    mute)
        send "🔇 Audio" "${MESSAGE:-Mute toggled}" low
        ;;
    screenshot)
        send "📸 Screenshot" "${MESSAGE:-Saved to clipboard}" low
        ;;
    system)
        send "⚙️ System" "${MESSAGE:-Command complete}" normal
        ;;
    error)
        send "❌ Error" "${MESSAGE:-Operation failed}" critical
        ;;
    *)
        send "Red Hood" "${MESSAGE:-Action complete}" low
        ;;
esac
