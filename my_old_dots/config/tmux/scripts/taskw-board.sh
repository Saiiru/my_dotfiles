#!/usr/bin/env bash
set -euo pipefail

if ! command -v task >/dev/null 2>&1; then
  echo "taskwarrior não encontrado ($PATH)" && read -r
  exit 0
fi

printf '=== TOP PRIORIDADES ===================================================\n'
task +PENDING rc.report.feed.columns=urgency,project,description rc.report.feed.labels=1 rc.report.feed.sort=urgency- next 2>/dev/null | head -n 8 || true

printf '\n=== WATCH LIST (flag +watch) ===========================================\n'
task +watch +PENDING rc.report.watch.columns=project,description rc.report.watch.labels=1 rc.report.watch.sort=project- all 2>/dev/null || true

printf '\n=== WATCH_DOGS OVERVIEW ================================================\n'
task watchdogs rc.report.watchdogs.width=200 2>/dev/null || true

printf '\n=== CONTEXTO ATIVO =====================================================\n'
task context show 2>/dev/null || true

if command -v timew >/dev/null 2>&1; then
  printf '\n=== TIMEW (última hora) ================================================\n'
  timew summary :hour 2>/dev/null | sed '1,2d'
fi

printf '\nPressione ENTER para fechar . . .'
read -r
