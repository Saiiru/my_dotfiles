#!/usr/bin/env bash
set -euo pipefail

LOG_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/neon-niri"
LOG_FILE="$LOG_DIR/gamemode.log"
mkdir -p "$LOG_DIR"

echo "[$(date '+%F %T')] GameMode start hook" >> "$LOG_FILE"

# Stop noisy services that contend with IO/CPU while gaming
systemctl --user stop tracker-miner-fs.service 2>/dev/null || true
systemctl --user stop evolution-calendar-factory.service 2>/dev/null || true

# Prefer deadline scheduler on NVMe devices for better latency
for dev in /sys/block/nvme*/queue/scheduler; do
    [[ -w "$dev" ]] || continue
    echo deadline | sudo tee "$dev" >/dev/null || true
done

# Small cache flush to avoid background IO bursts
sync || true
echo 3 | sudo tee /proc/sys/vm/drop_caches >/dev/null || true

# Optional: disable pointer acceleration if libinput exposes it
if command -v xinput >/dev/null 2>&1; then
    xinput --list | grep -i "pointer" | awk -F'id=' '{print $2}' | awk '{print $1}' | while read -r device_id; do
        xinput set-prop "$device_id" "libinput Accel Profile Enabled" 0 1 2>/dev/null || true
    done
fi

exit 0
