#═══════════════════════════════════════════════════════════════════════
# ZSH FUNCTIONS
# Purpose: Utility functions for common operations
#═══════════════════════════════════════════════════════════════════════

# ───────────────────────────────────────────────────────────────────────
# FUNCTION: mkcd — Create directory and cd into it
# Usage: mkcd <directory>
# Example: mkcd ~/projects/new-app
# ───────────────────────────────────────────────────────────────────────
mkcd() {
    if [[ -z "$1" ]]; then
        echo "Usage: mkcd <directory>"
        return 1
    fi
    mkdir -p "$1" && cd "$1"
}

# ───────────────────────────────────────────────────────────────────────
# FUNCTION: extract — Extract any archive type
# Usage: extract <archive-file>
# Supported: .tar.gz, .tar.bz2, .zip, .7z, .rar, etc.
# ───────────────────────────────────────────────────────────────────────
extract() {
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
        *.deb)            ar x "$1" ;;
        *)
            echo "Error: '$1' cannot be extracted via extract()"
            return 1
            ;;
    esac
}

# ───────────────────────────────────────────────────────────────────────
# FUNCTION: serve — Start HTTP server in current directory
# Usage: serve [port]
# Default port: 8000
# ───────────────────────────────────────────────────────────────────────
serve() {
    local port="${1:-8000}"
    echo "Serving at http://localhost:$port"
    python -m http.server "$port"
}

# ───────────────────────────────────────────────────────────────────────
# FUNCTION: backup — Create timestamped backup of file/directory
# Usage: backup <file-or-directory>
# Creates: <name>.bak.<timestamp>
# ───────────────────────────────────────────────────────────────────────
backup() {
    if [[ -z "$1" ]]; then
        echo "Usage: backup <file-or-directory>"
        return 1
    fi
    
    local timestamp=$(date +%Y%m%d_%H%M%S)
    cp -r "$1" "${1}.bak.${timestamp}"
    echo "✓ Backup created: ${1}.bak.${timestamp}"
}

# ───────────────────────────────────────────────────────────────────────
# FUNCTION: fcd — Fuzzy find and cd into directory
# Uses fzf to interactively select directory
# KEYBIND: Alt+C (via FZF, built-in)
# ───────────────────────────────────────────────────────────────────────
fcd() {
    local dir
    dir=$(fd --type d --hidden --follow --exclude .git . ${1:-.} 2>/dev/null | \
          fzf --preview 'eza --tree --level=2 --icons {} 2>/dev/null')
    [[ -n "$dir" ]] && cd "$dir"
}

# ───────────────────────────────────────────────────────────────────────
# FUNCTION: ff — Fuzzy find and edit file
# Uses fzf to select file, opens in $EDITOR
# KEYBIND: Ctrl+P (defined below)
# ───────────────────────────────────────────────────────────────────────
ff() {
    local file
    file=$(fd --type f --hidden --follow --exclude .git . ${1:-.} 2>/dev/null | \
           fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}')
    [[ -n "$file" ]] && ${EDITOR:-nvim} "$file"
}

# Widget for Ctrl+P
fzf-file-widget() {
    ff
    zle reset-prompt
}
zle -N fzf-file-widget

# KEYBIND: Ctrl+P — Fuzzy find and edit file
bindkey '^P' fzf-file-widget

# ───────────────────────────────────────────────────────────────────────
# FUNCTION: fkill — Fuzzy find and kill process
# Uses fzf to select process, then kills it
# ───────────────────────────────────────────────────────────────────────
fkill() {
    local pid
    pid=$(ps -ef | sed 1d | \
          fzf -m --height=60% --reverse \
              --preview='ps -p {2} -o pid,ppid,user,%cpu,%mem,stat,start,time,command' | \
          awk '{print $2}')
    
    if [[ -n "$pid" ]]; then
        echo "$pid" | xargs kill -${1:-15}
        echo "✓ Killed process(es): $pid"
    fi
}

# ───────────────────────────────────────────────────────────────────────
# FUNCTION: git-status-all — Show git status for all repos in directory
# Useful for checking status of multiple projects
# ───────────────────────────────────────────────────────────────────────
git-status-all() {
    for dir in */; do
        if [[ -d "$dir/.git" ]]; then
            echo -e "\n━━━ $dir ━━━"
            (cd "$dir" && git status -sb)
        fi
    done
}

# ───────────────────────────────────────────────────────────────────────
# FUNCTION: port-check — Check what's running on a port
# Usage: port-check <port>
# ───────────────────────────────────────────────────────────────────────
port-check() {
    if [[ -z "$1" ]]; then
        echo "Usage: port-check <port>"
        return 1
    fi
    sudo lsof -i ":$1"
}

# ───────────────────────────────────────────────────────────────────────
# FUNCTION: myip — Show local and public IP addresses
# ───────────────────────────────────────────────────────────────────────
myip() {
    echo "Local IP:  $(ip -4 addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v 127.0.0.1 | head -1)"
    echo "Public IP: $(curl -s ifconfig.me)"
}

# ───────────────────────────────────────────────────────────────────────
# FUNCTION: dsize — Show directory sizes, sorted
# Usage: dsize [directory]
# ───────────────────────────────────────────────────────────────────────
dsize() {
    du -sh "${@:-.}"/* 2>/dev/null | sort -h
}

# ───────────────────────────────────────────────────────────────────────
# FUNCTION: clean-cache — Clean all cache directories
# ───────────────────────────────────────────────────────────────────────
clean-cache() {
    echo "Cleaning caches..."
    [[ -d "$HOME/.cache" ]] && echo "User cache: $(du -sh "$HOME/.cache" | awk '{print $1}')"
    rm -rf "$HOME/.cache/"* 2>/dev/null
    echo "✓ Cache cleaned"
}
