#!/usr/bin/env bash
set -euo pipefail

if ! command -v task >/dev/null 2>&1; then
  echo "Σ:–"
  exit 0
fi

pending=$(task +PENDING count 2>/dev/null || echo 0)
watch=$(task +watch +PENDING count 2>/dev/null || echo 0)
next=$(task +PENDING rc.report.next.columns=description rc.report.next.labels=1 next 2>/dev/null | sed -n '1p' | cut -c1-30)

badge="Σ${pending}"
if [[ "${watch}" != "0" ]]; then
  badge+=" ▕ ⚑${watch}"
fi
if [[ -n "${next}" ]]; then
  badge+=" ▕ → ${next}"
fi

echo "${badge}"
