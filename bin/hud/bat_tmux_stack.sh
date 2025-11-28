#!/usr/bin/env bash
# bat_tmux_stack.sh - popup de layouts por stack (Java/Python/Go)
# Usa gum se presente; fallback simples se não.
# Cria janelas/panes na sessão tmux atual com layouts básicos.

set -euo pipefail

has() { command -v "$1" >/dev/null 2>&1; }

detect_stack() {
  if [[ -f pom.xml ]] || [[ -f build.gradle ]] || [[ -f build.gradle.kts ]]; then
    echo "java"
  elif [[ -f pyproject.toml ]]; then
    echo "python"
  elif [[ -f go.mod ]]; then
    echo "go"
  else
    echo "unknown"
  fi
}

choose() {
  local prompt="$1"; shift
  local options=("$@")
  if has gum; then
    printf "%s\n" "${options[@]}" | gum choose --header "$prompt"
  else
    echo "$prompt"
    local i=1
    for o in "${options[@]}"; do
      printf "  [%d] %s\n" "$i" "$o"
      i=$((i+1))
    done
    read -rp "> " sel
    echo "${options[$((sel-1))]}"
  fi
}

layout_java_api() {
  tmux new-window -c "#{pane_current_path}" -n "api" "mvnw spring-boot:run"
  tmux split-window -h -c "#{pane_current_path}" "lazygit || git status -sb; read"
  tmux select-pane -L
}

layout_java_qea() {
  tmux new-window -c "#{pane_current_path}" -n "qea" "mvnw test; read"
  tmux split-window -v -c "#{pane_current_path}" "mvnw verify; read"
  tmux select-layout even-vertical
}

layout_python_dev() {
  tmux new-window -c "#{pane_current_path}" -n "py-dev" "mise run py:dev || uv run python -m http.server 8000"
  tmux split-window -h -c "#{pane_current_path}" "mise run py:test || pytest; read"
  tmux select-pane -L
}

layout_go_dev() {
  tmux new-window -c "#{pane_current_path}" -n "go-dev" "mise run go:dev || go run ./cmd/server || go run ./..."
  tmux split-window -h -c "#{pane_current_path}" "mise run go:test || go test ./...; read"
  tmux select-pane -L
}

main() {
  local stack
  stack=$(detect_stack)

  case "$stack" in
    java)
      choice=$(choose "Layouts Java" "API + Git" "QEA Tests")
      case "$choice" in
        "API + Git") layout_java_api ;;
        "QEA Tests") layout_java_qea ;;
      esac
      ;;
    python)
      choice=$(choose "Layouts Python" "Dev + Tests")
      [[ "$choice" == "Dev + Tests" ]] && layout_python_dev
      ;;
    go)
      choice=$(choose "Layouts Go" "Dev + Tests")
      [[ "$choice" == "Dev + Tests" ]] && layout_go_dev
      ;;
    *)
      echo "Stack desconhecida (procura pom.xml / pyproject.toml / go.mod). Saindo."
      ;;
  esac
}

main "$@"
