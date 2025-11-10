#!/usr/bin/env bash
set -euo pipefail

if ! command -v task >/dev/null 2>&1; then
  echo "T:–"
  exit 0
fi

count="$(task +PENDING count 2>/dev/null || echo 0)"
next="$(task +PENDING rc.report.next.columns=description rc.report.next.labels=1 next 2>/dev/null | sed -n '1p' | cut -c1-30)"

if [[ -n "$next" ]]; then
  echo "T:${count} ▕ ${next}"
else
  echo "T:${count}"
fi
