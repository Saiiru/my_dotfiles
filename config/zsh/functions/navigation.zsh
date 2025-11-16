#!/usr/bin/env zsh
#═══════════════════════════════════════════════════════════════════════
# WORKSTATION OPS — Navigation Functions
# Sistema avançado de navegação e manipulação de diretórios
#═══════════════════════════════════════════════════════════════════════

#───────────────────────────────────────────────────────────────────────
# CD com LS automático
#───────────────────────────────────────────────────────────────────────

function cd() {
    builtin cd "$@" && command eza --icons --group-directories-first 2>/dev/null || command ls
}

#───────────────────────────────────────────────────────────────────────
# FCD — Busca interativa de diretório com preview
#───────────────────────────────────────────────────────────────────────

function fcd() {
    local dir
    dir=$(fd --type d --hidden --follow --exclude .git . ${1:-.} 2>/dev/null | \
          fzf --height=60% \
              --border=rounded \
              --prompt='Directory ❯ ' \
              --preview='eza --tree --level=2 --icons --color=always {} 2>/dev/null' \
              --preview-window='right:50%:wrap' \
              --color='fg:#00ff00,bg:#000000,hl:#ff073a' \
              --color='fg+:#00ffff,bg+:#1a1a1a,hl+:#ff073a' \
              --color='border:#ff073a,prompt:#00ff00')
    
    [[ -n "$dir" ]] && cd "$dir"
}

#───────────────────────────────────────────────────────────────────────
# FF — Busca e abre arquivo no editor
#───────────────────────────────────────────────────────────────────────

function ff() {
    local file
    file=$(fd --type f --hidden --follow --exclude .git . ${1:-.} 2>/dev/null | \
           fzf --height=60% \
               --border=rounded \
               --prompt='File ❯ ' \
               --preview='bat --color=always --style=numbers --line-range=:500 {} 2>/dev/null' \
               --preview-window='right:60%:wrap' \
               --color='fg:#00ff00,bg:#000000,hl:#ff073a' \
               --color='fg+:#00ffff,bg+:#1a1a1a,hl+:#ff073a' \
               --color='border:#ff073a,prompt:#00ff00')
    
    [[ -n "$file" ]] && ${EDITOR:-nvim} "$file"
}

# Widget para Ctrl+P
function fzf-file-widget() {
    ff
    zle reset-prompt
}
zle -N fzf-file-widget

# KEYBIND: Ctrl+P — Abre busca de arquivos e edita
bindkey '^P' fzf-file-widget

#───────────────────────────────────────────────────────────────────────
# MKCD — Cria e entra no diretório
#───────────────────────────────────────────────────────────────────────

function mkcd() {
    [[ -z "$1" ]] && echo "Usage: mkcd <directory>" && return 1
    mkdir -p "$1" && cd "$1"
}

#───────────────────────────────────────────────────────────────────────
# BACK — Volta múltiplos diretórios
#───────────────────────────────────────────────────────────────────────

function back() {
    local levels=${1:-1}
    local path=""
    for ((i=0; i<levels; i++)); do
        path="../$path"
    done
    cd "$path"
}

#───────────────────────────────────────────────────────────────────────
# UP — Navega para diretório pai específico
#───────────────────────────────────────────────────────────────────────

function up() {
    local d=""
    local limit="${1:-1}"
    for ((i=1; i<=limit; i++)); do
        d="../$d"
    done
    cd "${d:-.}" || return 1
}

#───────────────────────────────────────────────────────────────────────
# FASD-style quick access (se zoxide não disponível)
#───────────────────────────────────────────────────────────────────────

function j() {
    if command -v zoxide >/dev/null 2>&1; then
        z "$@"
    else
        cd "$@"
    fi
}

#───────────────────────────────────────────────────────────────────────
# TREE — Árvore colorida com limite de profundidade
#───────────────────────────────────────────────────────────────────────

function tree() {
    local level="${1:-2}"
    eza --tree --level="$level" --icons --color=always
}

#───────────────────────────────────────────────────────────────────────
# RECENT — Lista arquivos modificados recentemente
#───────────────────────────────────────────────────────────────────────

function recent() {
    local days="${1:-7}"
    fd --changed-within "${days}d" --exec ls -lht {} \; | head -20
}

#───────────────────────────────────────────────────────────────────────
# LARGEST — Encontra arquivos/diretórios maiores
#───────────────────────────────────────────────────────────────────────

function largest() {
    local limit="${1:-10}"
    du -ah . | sort -rh | head -n "$limit"
}
