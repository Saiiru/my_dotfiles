#!/usr/bin/env bash
set -euo pipefail

LOG_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/neon-niri"
LOG_FILE="$LOG_DIR/gamemode.log"
mkdir -p "$LOG_DIR"

echo "[$(date '+%F %T')] GameMode end hook" >> "$LOG_FILE"

# Restart services paused when entering performance mode
systemctl --user start tracker-miner-fs.service 2>/dev/null || true
systemctl --user start evolution-calendar-factory.service 2>/dev/null || true

# Restore default NVMe scheduler
for dev in /sys/block/nvme*/queue/scheduler; do
    [[ -w "$dev" ]] || continue
    echo mq-deadline | sudo tee "$dev" >/dev/null || true
done

exit 0
