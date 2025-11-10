#!/usr/bin/env bash
set -euo pipefail

STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/watchdogs-pomo"
STATE_FILE="$STATE_DIR/state.json"
TASK_LOCK="$STATE_DIR/task.lock"
LOG_FILE="$STATE_DIR/events.log"

ensure_dirs() {
  mkdir -p "$STATE_DIR"
}

require_jq() {
  if ! command -v jq >/dev/null 2>&1; then
    echo "pomodoro.sh precisa do jq (instale com sudo pacman -S jq)" >&2
    exit 1
  fi
}

has_jq() {
  command -v jq >/dev/null 2>&1
}

notify() {
  local body="$1"
  if command -v notify-send >/dev/null 2>&1; then
    notify-send -u low "Pomodoro" "$body"
  fi
}

start_focus() {
  ensure_dirs
  local mins="${1:-25}"
  local task_id="${2:-}"
  local now
  now=$(date +%s)
  jq -n --arg state "focus" \
        --argjson start "$now" \
        --argjson dur "$(( mins * 60 ))" \
        --arg task "$task_id" \
        '{state:$state,start:$start,duration:$dur,task:$task}' >"$STATE_FILE"

  if [[ -n "$task_id" ]] && command -v task >/dev/null 2>&1; then
    task "$task_id" start >/dev/null 2>&1 && echo "$task_id" >"$TASK_LOCK" || true
  elif command -v timew >/dev/null 2>&1; then
    timew start pomodoro >/dev/null 2>&1 || true
  fi
  printf '%s focus %s %s\n' "$now" "$mins" "$task_id" >>"$LOG_FILE"
  notify "Foco iniciado (${mins}m${task_id:+ · task $task_id})"
}

start_break() {
  ensure_dirs
  local mins="${1:-5}"
  local now
  now=$(date +%s)
  jq -n --arg state "break" \
        --argjson start "$now" \
        --argjson dur "$(( mins * 60 ))" \
        '{state:$state,start:$start,duration:$dur}' >"$STATE_FILE"
  stop_task_tracking || true
  command -v timew >/dev/null 2>&1 && timew start pomodoro_break >/dev/null 2>&1 || true
  printf '%s break %s\n' "$now" "$mins" >>"$LOG_FILE"
  notify "Intervalo (${mins}m)"
}

stop_task_tracking() {
  if [[ -f "$TASK_LOCK" ]]; then
    local task_id
    task_id=$(<"$TASK_LOCK")
    if command -v task >/dev/null 2>&1; then
      task "$task_id" stop >/dev/null 2>&1 || true
    fi
    rm -f "$TASK_LOCK"
  fi
  if command -v timew >/dev/null 2>&1; then
    timew stop >/dev/null 2>&1 || true
  fi
}

stop_all() {
  stop_task_tracking || true
  rm -f "$STATE_FILE"
  notify "Pomodoro parado"
}

complete_cycle() {
  local state="$1"
  if [[ "$state" == "focus" ]]; then
    notify "Foco concluído. Respire e registre o resultado."
  else
    notify "Intervalo encerrado. Hora do próximo foco."
  fi
  stop_task_tracking || true
  rm -f "$STATE_FILE"
}

print_status() {
  if [[ ! -f "$STATE_FILE" ]]; then
    echo ""
    return 0
  fi

  if ! has_jq; then
    echo "⏱ --:--"
    return 0
  fi
  local now state start dur task_id left prefix color
  now=$(date +%s)
  state=$(jq -r '.state' "$STATE_FILE")
  start=$(jq -r '.start' "$STATE_FILE")
  dur=$(jq -r '.duration' "$STATE_FILE")
  task_id=$(jq -r '.task // ""' "$STATE_FILE")
  left=$(( start + dur - now ))

  if (( left <= 0 )); then
    complete_cycle "$state"
    echo ""
    return 0
  fi

  local min=$(( left / 60 ))
  local sec=$(( left % 60 ))
  if [[ "$state" == "focus" ]]; then
    prefix="FOC"
    color="#1AFFA3"
  else
    prefix="BRK"
    color="#8BD7BF"
  fi
  if [[ -n "$task_id" && "$task_id" != "null" ]]; then
    task_id="@$task_id"
  else
    task_id=""
  fi
  printf '#[fg=%s]%s %02d:%02d%s' "$color" "$prefix" "$min" "$sec" "$task_id"
}

case "${1:-status}" in
  start|focus)
    require_jq
    shift || true
    start_focus "${1:-25}" "${2:-}"
    ;;
  break)
    require_jq
    shift || true
    start_break "${1:-5}"
    ;;
  toggle)
    require_jq
    shift || true
    if [[ -f "$STATE_FILE" ]]; then
      stop_all
    else
      start_focus "${1:-25}" "${2:-}"
    fi
    ;;
  stop)
    stop_all
    ;;
  status)
    print_status
    ;;
  popup)
    require_jq
    ensure_dirs
    while true; do
      clear
      if [[ -f "$STATE_FILE" ]]; then
        jq '.' "$STATE_FILE"
        echo
        echo "[enter] atualiza · [f] foco 25 · [b] break 5 · [s] stop · [q] sai"
      else
        echo "Nenhum ciclo em andamento."
        echo "[f] foco 25 · [b] break 5 · [q] sai"
      fi
      read -r -t 1 key || true
      case "$key" in
        f) start_focus 25; ;;
        b) start_break 5; ;;
        s) stop_all; ;;
        q) exit 0; ;;
        *) continue ;;
      esac
    done
    ;;
  *)
    echo "Usage: pomodoro.sh {start|focus|break|toggle|stop|status|popup} [minutes] [task_id]" >&2
    exit 1
    ;;
 esac
