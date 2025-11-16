#!/usr/bin/env zsh
#═══════════════════════════════════════════════════════════════════════
# WORKSTATION OPS — Development Functions
# Ferramentas táticas de desenvolvimento
#═══════════════════════════════════════════════════════════════════════

#───────────────────────────────────────────────────────────────────────
# RGI — Ripgrep interativo com editor
#───────────────────────────────────────────────────────────────────────

function rgi() {
    rg --color=always --line-number --no-heading --smart-case "${*:-}" 2>/dev/null |
        fzf --ansi \
            --delimiter=: \
            --height=60% \
            --border=rounded \
            --prompt='Search ❯ ' \
            --preview='bat --color=always {1} --highlight-line {2} 2>/dev/null' \
            --preview-window='up,60%,border-bottom,+{2}+3/3,~3' \
            --color='fg:#00ff00,bg:#000000,border:#ff073a' \
            --bind='enter:become(nvim {1} +{2})'
}

# Widget para Ctrl+G
function fzf-ripgrep-widget() {
    rgi
    zle reset-prompt
}
zle -N fzf-ripgrep-widget

# KEYBIND: Ctrl+G — Busca de código interativa
bindkey '^G' fzf-ripgrep-widget

#───────────────────────────────────────────────────────────────────────
# FKILL — Kill de processos interativo
#───────────────────────────────────────────────────────────────────────

function fkill() {
    local pid
    pid=$(ps -ef | sed 1d | 
          fzf -m \
              --height=60% \
              --border=rounded \
              --prompt='Kill process ❯ ' \
              --preview='ps -p {2} -o pid,ppid,user,%cpu,%mem,stat,start,time,command' \
              --preview-window='down:5:wrap' \
              --color='fg:#00ff00,bg:#000000,border:#ff073a' | 
          awk '{print $2}')
    
    [[ -n "$pid" ]] && echo "$pid" | xargs kill -${1:-15}
}

#───────────────────────────────────────────────────────────────────────
# DEX — Docker exec interativo
#───────────────────────────────────────────────────────────────────────

function dex() {
    local container
    container=$(docker ps --format '{{.Names}}' | 
                fzf --height=40% \
                    --border=rounded \
                    --prompt='Container ❯ ' \
                    --preview='docker inspect {} | bat --color=always -l json' \
                    --color='fg:#00ff00,bg:#000000,border:#ff073a')
    
    [[ -n "$container" ]] && docker exec -it "$container" "${@:-bash}"
}

# Widget para Ctrl+D E
function fzf-docker-exec-widget() {
    dex
    zle reset-prompt
}
zle -N fzf-docker-exec-widget

# KEYBIND: Ctrl+D E — Docker exec interativo
bindkey '^De' fzf-docker-exec-widget

#───────────────────────────────────────────────────────────────────────
# DLOGS — Docker logs interativo
#───────────────────────────────────────────────────────────────────────

function dlogs() {
    local container
    container=$(docker ps --format '{{.Names}}' | 
                fzf --height=40% \
                    --border=rounded \
                    --prompt='Container logs ❯ ' \
                    --color='fg:#00ff00,bg:#000000,border:#ff073a')
    
    [[ -n "$container" ]] && docker logs -f "$container"
}

#───────────────────────────────────────────────────────────────────────
# EXTRACT — Extrai qualquer arquivo comprimido
#───────────────────────────────────────────────────────────────────────

function extract() {
    if [[ ! -f "$1" ]]; then
        echo "Error: '$1' is not a valid file"
        return 1
    fi
    
    case "$1" in
        *.tar.bz2|*.tbz2) tar xjf "$1" ;;
        *.tar.gz|*.tgz)   tar xzf "$1" ;;
        *.tar.xz|*.txz)   tar xJf "$1" ;;
        *.tar.zst)        tar --zstd -xf "$1" ;;
        *.bz2)            bunzip2 "$1" ;;
        *.rar)            unrar x "$1" ;;
        *.gz)             gunzip "$1" ;;
        *.tar)            tar xf "$1" ;;
        *.zip)            unzip "$1" ;;
        *.Z)              uncompress "$1" ;;
        *.7z)             7z x "$1" ;;
        *.xz)             unxz "$1" ;;
        *)                echo "Error: '$1' cannot be extracted" && return 1 ;;
    esac
}

#───────────────────────────────────────────────────────────────────────
# SERVE — HTTP server rápido
#───────────────────────────────────────────────────────────────────────

function serve() {
    local port="${1:-8000}"
    echo "Serving at http://localhost:$port"
    python -m http.server "$port"
}

#───────────────────────────────────────────────────────────────────────
# JSONPP — JSON pretty print
#───────────────────────────────────────────────────────────────────────

function jsonpp() {
    if [[ -n "$1" ]]; then
        cat "$1" | jq .
    else
        jq .
    fi
}

#───────────────────────────────────────────────────────────────────────
# PORTCHECK — Verifica porta em uso
#───────────────────────────────────────────────────────────────────────

function portcheck() {
    [[ -z "$1" ]] && echo "Usage: portcheck <port>" && return 1
    sudo lsof -i ":$1"
}

#───────────────────────────────────────────────────────────────────────
# MYIP — Mostra IPs (local e público)
#───────────────────────────────────────────────────────────────────────

function myip() {
    echo "Local IP:  $(ip -4 addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v 127.0.0.1 | head -1)"
    echo "Public IP: $(curl -s ifconfig.me)"
}
