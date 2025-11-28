#!/usr/bin/env bash
# BAT NEW PROJECT GENERATOR
# Gera projeto a partir de starters (java/python/go), substitui placeholders
# e cria .batproj para o BAT-HUD / tmux stack.

set -euo pipefail

TEMPLATE_ROOT="${TEMPLATE_ROOT:-$HOME/github/starters}"
TARGET_ROOT="${TARGET_ROOT:-$HOME/github}"

log()  { printf '[-] %s\n' "$*"; }
ok()   { printf '[✓] %s\n' "$*"; }
err()  { printf '[✗] %s\n' "$*" >&2; }

usage() {
  cat <<'USAGE'
Uso: $(basename "$0") [opções]

  -s, --stack <java|python|go>
  --slug <kebab>
  --title <Título>
  --java-package <pkg>
  --py-package <pkg>
  --go-module <module>
  --dir <destino>   (default: $TARGET_ROOT)
USAGE
}

prompt_if_empty() {
  local var="$1" prompt="$2" default="${3:-}" value
  local current="${!var:-}"
  if [[ -n "$current" ]]; then return; fi
  if [[ -n "$default" ]]; then
    read -r -p "$prompt [$default]: " value; value="${value:-$default}"
  else
    read -r -p "$prompt: " value
  fi
  eval "$var=\"$value\""
}

replace_placeholder() {
  local pattern="$1" value="$2"
  [[ -z "$value" ]] && return 0
  find . -type f ! -path "*/.git/*" -print0 | xargs -0 sed -i "s|$pattern|$value|g"
}

STACK=""; APP_SLUG=""; APP_TITLE=""; JAVA_PACKAGE=""; PY_PACKAGE=""; GO_MODULE=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    -s|--stack) STACK="$2"; shift 2;;
    --slug) APP_SLUG="$2"; shift 2;;
    --title) APP_TITLE="$2"; shift 2;;
    --java-package) JAVA_PACKAGE="$2"; shift 2;;
    --py-package) PY_PACKAGE="$2"; shift 2;;
    --go-module) GO_MODULE="$2"; shift 2;;
    --dir) TARGET_ROOT="$2"; shift 2;;
    -h|--help) usage; exit 0;;
    *) err "Arg desconhecido: $1"; usage; exit 1;;
  esac
done

prompt_if_empty STACK "Stack (java|python|go)" "java"
case "$STACK" in java|python|go) ;; *) err "Stack inválida: $STACK"; exit 1;; esac
prompt_if_empty APP_SLUG "Slug (kebab-case)" "demo-api"
prompt_if_empty APP_TITLE "Título" "Demo API"

if [[ "$STACK" == "java" ]]; then
  prompt_if_empty JAVA_PACKAGE "Pacote Java" "com.batcave.${APP_SLUG//-/.}"
elif [[ "$STACK" == "python" ]]; then
  prompt_if_empty PY_PACKAGE "Pacote Python" "batcave.${APP_SLUG//-/_}"
elif [[ "$STACK" == "go" ]]; then
  prompt_if_empty GO_MODULE "Módulo Go" "github.com/$(whoami)/$APP_SLUG"
fi

case "$STACK" in
  java)   TEMPLATE_DIR="$TEMPLATE_ROOT/starter-java-api" ;;
  python) TEMPLATE_DIR="$TEMPLATE_ROOT/starter-python-tooling" ;;
  go)     TEMPLATE_DIR="$TEMPLATE_ROOT/starter-go-api" ;;
esac

if [[ ! -d "$TEMPLATE_DIR" ]]; then err "Template não encontrado: $TEMPLATE_DIR"; exit 1; fi
TARGET_DIR="$TARGET_ROOT/$APP_SLUG"
if [[ -e "$TARGET_DIR" ]]; then err "Destino já existe: $TARGET_DIR"; exit 1; fi

log "Criando projeto em: $TARGET_DIR"
mkdir -p "$TARGET_DIR"
if command -v rsync >/dev/null 2>&1; then
  rsync -a --exclude ".git" "$TEMPLATE_DIR"/ "$TARGET_DIR"/
else
  cp -R "$TEMPLATE_DIR"/. "$TARGET_DIR"/
  rm -rf "$TARGET_DIR/.git" || true
fi

cd "$TARGET_DIR"
replace_placeholder "__APP_SLUG__" "$APP_SLUG"
replace_placeholder "__APP_TITLE__" "$APP_TITLE"
replace_placeholder "__JAVA_PACKAGE__" "$JAVA_PACKAGE"
replace_placeholder "__PY_PACKAGE__" "$PY_PACKAGE"
replace_placeholder "__GO_MODULE__" "$GO_MODULE"

cat > .batproj <<EOF_PROJ
STACK=$STACK
APP_SLUG=$APP_SLUG
APP_TITLE="$APP_TITLE"
JAVA_PACKAGE="$JAVA_PACKAGE"
PY_PACKAGE="$PY_PACKAGE"
GO_MODULE="$GO_MODULE"
EOF_PROJ
ok ".batproj criado"

if command -v git >/dev/null 2>&1 && ! git rev-parse --git-dir >/dev/null 2>&1; then
  log "Inicializando git..."
  git init -b main >/dev/null 2>&1 || git init >/dev/null 2>&1
  git add .
  git commit -m "chore: bootstrap $APP_SLUG from $STACK starter" >/dev/null 2>&1 || true
  ok "Repo git inicializado"
fi

ok "Projeto pronto: $TARGET_DIR"
echo "Dicas:"
echo "  cd \"$TARGET_DIR\""
echo "  mise run hud        # HUD"
echo "  mise run tmux-stack  # tmux layout dev/test/logs"
