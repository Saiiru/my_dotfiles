# Funções DRAGON-VEGA

_batcave_ctx_file="${XDG_STATE_HOME:-$HOME/.local/state}/neon-niri/context"

batcave_context() {
  if [[ -f "$_batcave_ctx_file" ]]; then
    printf "%s" "$(tr '[:lower:]' '[:upper:]' < "$_batcave_ctx_file")"
  else
    printf "UNKNOWN"
  fi
}

dragon_dev() {
  local dir="${1:-$PWD}"
  cd "$dir" || return 1

  if [[ -f "mise.toml" || -f ".mise.toml" || -f ".tool-versions" ]]; then
    echo "[BATCAVE] mise detected in $PWD"
  fi

  if command -v tmux >/dev/null 2>&1; then
    tmux new -A -s dev 'zsh'
  else
    echo "[BATCAVE] tmux not installed"
  fi
}

bat_project_root() {
  if command git rev-parse --show-toplevel >/dev/null 2>&1; then
    git rev-parse --show-toplevel
  else
    printf "%s" "$PWD"
  fi
}

bat_dev() {
  local root
  root="$(bat_project_root)"
  cd "$root" || return 1

  if [[ -f "mise.toml" || -f ".mise.toml" ]]; then
    echo "[BATMAN] mise config detectado em $root"
  fi

  if command -v tmux >/dev/null 2>&1; then
    tmux new -A -s dev "cd '$root'; zsh"
  else
    zsh
  fi
}

bat_java_check()   { mise run java-env   2>/dev/null || true; }
bat_node_check()   { mise run node-env   2>/dev/null || true; }
bat_go_check()     { mise run go-env     2>/dev/null || true; }
bat_python_check() { mise run python-env 2>/dev/null || true; }
bat_rust_check()   { mise run rust-env   2>/dev/null || true; }

qa_http_json() {
  if (( $# < 2 )); then
    echo "usage: qa_http_json METHOD URL [JSON_BODY]"
    return 1
  fi

  local method="$1"
  local url="$2"
  local body="${3:-}"

  if command -v http >/dev/null 2>&1; then
    if [[ -n "$body" ]]; then
      printf "%s\n" "$body" | http "$method" "$url" Content-Type:application/json
    else
      http "$method" "$url"
    fi
  else
    if [[ -n "$body" ]]; then
      curl -X "$method" -H "Content-Type: application/json" -d "$body" "$url"
    else
      curl -X "$method" "$url"
    fi
  fi
}

qa_db_ping() {
  echo "Implementar: conectar ao banco padrão da squad e rodar SELECT 1; conforme stack."
}

batcave_reload() {
  source "$HOME/.zshrc"
  echo "[BATCAVE] shell reloaded"
}

# Vai para a raiz do repositório git atual (seguro; avisa se não for repo)
groot() {
  if git rev-parse --show-toplevel >/dev/null 2>&1; then
    cd "$(git rev-parse --show-toplevel)" || return 1
  else
    echo "[batcave] não está em um repositório git" >&2
    return 1
  fi
}
