#!/usr/bin/env bash

set -euo pipefail

capacity="∞"
if compgen -G "/sys/class/power_supply/BAT*/capacity" >/dev/null; then
    capacity="$(cat /sys/class/power_supply/BAT*/capacity 2>/dev/null | head -n1)%"
fi

uptime="$(uptime -p | sed 's/up //')"

echo "⚡ $capacity  ⏱ $uptime"
