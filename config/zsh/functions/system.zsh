#!/usr/bin/env zsh
#═══════════════════════════════════════════════════════════════════════
# WORKSTATION OPS — System Functions
# Utilitários avançados de sistema e manutenção
#═══════════════════════════════════════════════════════════════════════

#───────────────────────────────────────────────────────────────────────
# RELOAD — Recarrega shell
#───────────────────────────────────────────────────────────────────────

function reload() {
    exec zsh
}

#───────────────────────────────────────────────────────────────────────
# BAK — Backup rápido com timestamp
#───────────────────────────────────────────────────────────────────────

function bak() {
    [[ -z "$1" ]] && echo "Usage: bak <file>" && return 1
    cp -r "$1" "${1}.bak.$(date +%Y%m%d_%H%M%S)"
    echo "✓ Backup: ${1}.bak.$(date +%Y%m%d_%H%M%S)"
}

#───────────────────────────────────────────────────────────────────────
# DSIZE — Tamanho de diretórios ordenado
#───────────────────────────────────────────────────────────────────────

function dsize() {
    du -sh "${@:-.}"/* 2>/dev/null | sort -h
}

#───────────────────────────────────────────────────────────────────────
# CLEAN-CACHE — Limpa caches do sistema
#───────────────────────────────────────────────────────────────────────

function clean-cache() {
    echo "Limpando caches do sistema..."
    [[ -d "$HOME/.cache" ]] && echo "User cache: $(du -sh "$HOME/.cache" | awk '{print $1}')"
    rm -rf "$HOME/.cache/"* 2>/dev/null
    echo "✓ Cache limpo"
}

#───────────────────────────────────────────────────────────────────────
# WEATHER — Clima no terminal
#───────────────────────────────────────────────────────────────────────

function weather() {
    curl "wttr.in/${1:-}"
}

#───────────────────────────────────────────────────────────────────────
# CHEAT — Cheatsheet rápido
#───────────────────────────────────────────────────────────────────────

function cheat() {
    curl "cheat.sh/${1}"
}

#───────────────────────────────────────────────────────────────────────
# CLIP — Copia para clipboard
#───────────────────────────────────────────────────────────────────────

function clip() {
    if command -v wl-copy >/dev/null 2>&1; then
        wl-copy < "${1:-/dev/stdin}"
    elif command -v xclip >/dev/null 2>&1; then
        xclip -selection clipboard < "${1:-/dev/stdin}"
    else
        echo "Error: wl-copy ou xclip não instalado"
        return 1
    fi
}

#───────────────────────────────────────────────────────────────────────
# PASTE — Cola do clipboard
#───────────────────────────────────────────────────────────────────────

function paste() {
    if command -v wl-paste >/dev/null 2>&1; then
        wl-paste
    elif command -v xclip >/dev/null 2>&1; then
        xclip -selection clipboard -o
    else
        echo "Error: wl-paste ou xclip não instalado"
        return 1
    fi
}

#───────────────────────────────────────────────────────────────────────
# SYSHEALTH — Health check do sistema
#───────────────────────────────────────────────────────────────────────

function syshealth() {
    echo "╔════════════════════════════════════════╗"
    echo "║  SYSTEM HEALTH CHECK                   ║"
    echo "╚════════════════════════════════════════╝"
    echo
    echo "[CPU]"
    top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}'
    echo
    echo "[Memory]"
    free -h | awk '/^Mem:/ {print $3 " / " $2 " (" int($3/$2 * 100) "%)"}'
    echo
    echo "[Disk]"
    df -h / | awk 'NR==2 {print $3 " / " $2 " (" $5 ")"}'
    echo
    echo "[Load Average]"
    uptime | awk -F'load average:' '{print $2}'
}

#───────────────────────────────────────────────────────────────────────
# PKGINFO — Info sobre pacote instalado
#───────────────────────────────────────────────────────────────────────

function pkginfo() {
    [[ -z "$1" ]] && echo "Usage: pkginfo <package>" && return 1
    paru -Qi "$1" 2>/dev/null || paru -Si "$1"
}

#───────────────────────────────────────────────────────────────────────
# ORPHANS — Lista pacotes órfãos
#───────────────────────────────────────────────────────────────────────

function orphans() {
    local orphans=$(paru -Qtdq)
    if [[ -z "$orphans" ]]; then
        echo "✓ No orphaned packages"
    else
        echo "Orphaned packages:"
        echo "$orphans"
        echo
        read "?Remove all? (y/N): " response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            echo "$orphans" | xargs paru -Rns
        fi
    fi
}
