#!/usr/bin/env bash
# BAT-HUD minimal, agora lendo .batproj para mostrar o nome do projeto.
set -euo pipefail

BAT_STACK=""
BAT_APP_SLUG=""
BAT_APP_TITLE=""

load_batproj() {
  if [[ -f ".batproj" ]]; then
    # shellcheck disable=SC1091
    . ./.batproj 2>/dev/null || true
    BAT_STACK="${STACK:-$BAT_STACK}"
    BAT_APP_SLUG="${APP_SLUG:-$BAT_APP_SLUG}"
    BAT_APP_TITLE="${APP_TITLE:-$BAT_APP_TITLE}"
  fi
}

project_name() {
  if [[ -n "${BAT_APP_TITLE:-}" ]]; then
    echo "$BAT_APP_TITLE"
    return
  fi
  if [[ -n "${BAT_APP_SLUG:-}" ]]; then
    echo "$BAT_APP_SLUG"
    return
  fi
  echo "${PWD##*/}"
}

hud_global() {
  RED="$(tput setaf 9 2>/dev/null || echo '')"
  CYAN="$(tput setaf 45 2>/dev/null || echo '')"
  RESET="$(tput sgr0 2>/dev/null || echo '')"

  cat <<EOF
${RED}       _,    _   _    ,_
  .o888P     Y8o8Y     Y888o.
 d88888      88888      88888b
d888888b_  _d88888b_  _d888888b
8888888888888888888888888888888
8888888888888888888888888888888
YJGS8P"Y888P"Y888P"Y888P"Y8888P
 Y888   '8'   Y8P   '8'   888Y
  '8o          V          o8'${RESET}

${CYAN} BATCOMPUTER · DRAGON–OPS · GOTHAM DEV / CLOUD STACK${RESET}
 JAVA   · Core APIs / Domínio · “Batman”
 PYTHON · Automação / Glue    · “Nightwing”
 GO     · Services / Daemons  · “Red Hood”
 ORACLE · Cloud / Observability · “Oracle (Barbara)”
EOF
}

print_project_block() {
  local name
  name=$(project_name)
  echo
  echo " PROJECT"
  echo "   🦇 Name : $name"
  echo "   📁 Path : $PWD"
  if [[ -n "${BAT_STACK:-}" ]]; then
    echo "   🧩 Stack: $BAT_STACK"
  fi
}

main() {
  load_batproj
  hud_global
  print_project_block
}

main "$@"
