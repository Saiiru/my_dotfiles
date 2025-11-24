#!/usr/bin/env bash
# Simple swaylock-based lock script
set -euo pipefail

if ! command -v swaylock >/dev/null 2>&1; then
  echo "swaylock not found" >&2
  exit 1
fi

BG="#050814"
FG="#d7e6ff"
RING="#3fb5ff"
WRONG="#ff4d73"
CLEAR="#ffd65a"
VERIFY="#40f59a"

exec swaylock \
  --screenshots \
  --effect-blur 10x3 \
  --indicator \
  --indicator-radius 110 \
  --indicator-thickness 8 \
  --inside-color "$BG" \
  --ring-color "$RING" \
  --key-hl-color "$VERIFY" \
  --separator-color "$BG" \
  --line-color "$BG" \
  --inside-clear-color "$BG" \
  --ring-clear-color "$CLEAR" \
  --inside-ver-color "$BG" \
  --ring-ver-color "$VERIFY" \
  --inside-wrong-color "$BG" \
  --ring-wrong-color "$WRONG" \
  --text-color "$FG" \
  --text-clear-color "$FG" \
  --text-wrong-color "$FG" \
  --text-ver-color "$FG"
