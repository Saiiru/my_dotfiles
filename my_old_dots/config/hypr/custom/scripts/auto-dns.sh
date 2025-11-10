#!/usr/bin/env bash
# Ensure DNS profile applied at login.

set -euo pipefail

provider="${OMARCHY_DNS_PROVIDER:-}"

if [[ -z "$provider" ]]; then
    config_file="${XDG_CONFIG_HOME:-$HOME/.config}/omarchy/dns-provider"
    if [[ -r "$config_file" ]]; then
        read -r provider < "$config_file"
    fi
fi

if [[ -z "$provider" ]]; then
    # No provider configured; skip automatic DNS changes.
    exit 0
fi

if ! command -v omarchy-setup-dns >/dev/null; then
    exit 0
fi

log_file="${XDG_STATE_HOME:-$HOME/.local/state}/omarchy/dns.log"
mkdir -p "$(dirname "$log_file")"

{
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] applying DNS provider: $provider"
    omarchy-setup-dns "$provider"
} >> "$log_file" 2>&1
