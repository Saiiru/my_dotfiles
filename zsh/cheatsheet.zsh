# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# cheatsheet.zsh — Quick reference + helper aliases
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

__redhood_print_file() {
  local file="$1"
  if [[ ! -f "$file" ]]; then
    echo "⚠ cheatsheet: missing file $file" >&2
    return 1
  fi
  if command -v bat >/dev/null 2>&1; then
    bat --style=plain --pager="less -R" "$file"
  else
    less -R "$file"
  fi
}

zsh_cheatsheet() {
  cat <<'EOF'
󰌪  Zsh Quick Actions (Red Hood)
────────────────────────────────
  ff              → fuzzy open files in $EDITOR
  fcd             → cd into directory via zoxide + fzf
  fh              → fuzzy search history, press enter to run
  fbr             → checkout git branch (local/remote)
  fkill           → kill processes selected via fzf
  misetask / mt   → pick a mise task via fzf and run it
  cheat           → show this summary
  zcheat          → same as above (alias)

Python helpers
  pyvenv          → mise run python:venv
  pysetup         → mise run py:install
  pydev           → mise run py:dev-install
  pytestall       → mise run py:test
  pycov           → mise run py:coverage
  pyfmt           → mise run py:fmt
  pycheck         → mise run py:lint
  pyactivate      → source .venv/bin/activate (if present)

Java / Go / Node helpers
  javadev         → mise run session:java
  nodeinstall     → mise run node:install
  nodebuild       → mise run node:build
  nodedev         → mise run node:dev
  nodetest        → mise run node:test
  gofmtproj       → mise run go:fmt
  gotest          → mise run go:test
  miselogs        → mise run docker:logs (if docker compose project)

Cheatsheets
  mcheat          → open mise cheatsheet
  ncheat          → open Neovim cheatsheet
  cheat           → show this overview again
EOF
}

redhood_cheatsheet() { zsh_cheatsheet; }

mise_cheatsheet() { __redhood_print_file "$HOME/dotfiles/mise_cheatsheet.md"; }
nvim_cheatsheet() { __redhood_print_file "$HOME/dotfiles/config/nvim/CHEATSHEET.md"; }

misetask() {
  command -v mise >/dev/null 2>&1 || { echo "⚠ mise not installed"; return 1; }
  local task
  task=$(mise tasks 2>/dev/null | fzf --prompt="mise task ❯ " --height=40% --layout=reverse)
  [[ -n "$task" ]] && mise run "$task"
}

# helper alias shortcuts now live in zsh/aliases/aliases.zsh
pyactivate() {
  if [[ -d .venv && -f .venv/bin/activate ]]; then
    source .venv/bin/activate
  else
    echo "⚠ .venv not found. Run pyvenv first."
    return 1
  fi
}
