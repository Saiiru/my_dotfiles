#!/usr/bin/env bash
# Pequeno helper pra suspender com lock antes (se swaylock existir).
set -euo pipefail

if command -v swaylock >/dev/null 2>&1; then
  swaylock || true
fi

systemctl suspend

