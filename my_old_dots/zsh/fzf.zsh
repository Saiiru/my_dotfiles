# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# fzf.zsh — FZF integrations + widgets
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# System keybindings (Arch)
[[ -r /usr/share/fzf/key-bindings.zsh ]] && source /usr/share/fzf/key-bindings.zsh
[[ -r /usr/share/fzf/completion.zsh ]] && source /usr/share/fzf/completion.zsh

# Fallback to fzf native
command -v fzf >/dev/null && source <(fzf --zsh) 2>/dev/null

# Preview helper (runs inside bash for portability)
export FZF_PREVIEW_COMMAND=$'bash -c \'if [ -d "$1" ]; then if command -v eza >/dev/null 2>&1; then eza --icons --tree --level=2 --color=always "$1" | head -200; else ls -la "$1" | head -200; fi; else if command -v bat >/dev/null 2>&1; then bat --style=plain --color=always --line-range=:300 "$1"; else head -300 "$1"; fi; fi\' _ {}'

# Custom widgets
# ff - fuzzy file edit
ff() {
  local files
  files=$(fzf --multi --preview "$FZF_PREVIEW_COMMAND")
  if [[ -n "$files" ]]; then
    local -a selection
    selection=("${(@f)files}")
    ${EDITOR:-nvim} "${selection[@]}"
  fi
}

# fcd - fuzzy cd with zoxide
fcd() {
  if ! command -v zoxide >/dev/null 2>&1; then
    echo "⚠ zoxide não instalado"
    return 1
  fi
  local dir
  dir=$(zoxide query -l | fzf --height=50% --layout=reverse --prompt="📁 ")
  [[ -n "$dir" ]] && cd "$dir"
}

# fh - fuzzy history
fh() {
  local cmd
  cmd=$(fc -l 1 | tac | fzf --height=50% --layout=reverse --prompt="⚡ ")
  [[ -n "$cmd" ]] && print -z "${cmd##*}"
}

# fbr - fuzzy git branch
fbr() {
  git rev-parse --git-dir >/dev/null 2>&1 || return
  local branch
  branch=$(git branch --all | grep -v 'HEAD' | sed 's#remotes/origin/##' | sed 's/^\* //' | sort -u | fzf --prompt="🌿 ")
  [[ -n "$branch" ]] && git checkout "$branch"
}

# fkill - fuzzy process kill
fkill() {
  local pid
  pid=$(ps -ef | sed 1d | fzf -m --height=50% --prompt="💀 " | awk '{print $2}')
  [[ -n "$pid" ]] && kill -9 "$pid"
}
