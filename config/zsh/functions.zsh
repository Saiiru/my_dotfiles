mkcd() {
    mkdir -p "$1" && cd "$1"
}

up() {
    local count=${1:-1}
    local path=""
    for ((i=0; i<count; i++)); do
        path="../$path"
    done
    cd "$path" || return
}

extract() {
    if [[ -f "$1" ]]; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1" ;;
            *.tar.gz)    tar xzf "$1" ;;
            *.tar.xz)    tar xJf "$1" ;;
            *.bz2)       bunzip2 "$1" ;;
            *.rar)       unrar x "$1" ;;
            *.gz)        gunzip "$1" ;;
            *.tar)       tar xf "$1" ;;
            *.tbz2)      tar xjf "$1" ;;
            *.tgz)       tar xzf "$1" ;;
            *.zip)       unzip "$1" ;;
            *.Z)         uncompress "$1" ;;
            *.7z)        7z x "$1" ;;
            *)           echo "'$1' cannot be extracted" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

gac() {
    git add -A
    if [[ -z "$1" ]]; then
        git commit -m "Update: $(date '+%Y-%m-%d %H:%M:%S')"
    else
        git commit -m "$1"
    fi
}

gacp() {
    gac "$1"
    git push
}

ctx-info() {
    local context=$(cat ${XDG_STATE_HOME}/neon-niri/system-context 2>/dev/null || echo "UNKNOWN")
    local cpu_gov=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor 2>/dev/null || echo "unknown")
    cat <<EOF_CTX
╔════════════════════════════════════════╗
║      NEON-NIRI System Context          ║
╠════════════════════════════════════════╣
║ Context:     $context
║ CPU Governor: $cpu_gov
║ Config:      ~/.config/niri/config.kdl.active
╚════════════════════════════════════════╝
EOF_CTX
}

niri-help() {
    cat <<'EOF_HELP'
╔══════════════════════════════════════════════════════════════════════════╗
║                      NEON-NIRI v2 - QUICK REFERENCE                      ║
╚══════════════════════════════════════════════════════════════════════════╝

CONTEXT SWITCHING:
  Mod+F11          Switch to DEV mode
  Mod+F12          Switch to GAME mode
  Mod+Shift+F12    Switch to DEFAULT mode

  CLI:
    ctx-dev        Switch to DEV mode
    ctx-game       Switch to GAME mode
    ctx-default    Switch to DEFAULT mode
    ctx-status     Show current context
    ctx-info       Show detailed context info

GAMING:
  Mod+G            Launch game (menu)
  Mod+M            Mute/unmute microphone
  Mod+F1           Toggle FPS overlay
  Mod+F3           Launch Steam

NAVIGATION:
  Mod+H/J/K/L      Focus windows (vim style)
  Mod+1-9          Switch workspace
  Mod+Shift+1-9    Move window to workspace

WINDOW MANAGEMENT:
  Mod+Return       Open terminal
  Mod+D            Open launcher
  Mod+F            Toggle fullscreen
  Mod+Space        Toggle floating
  Mod+Shift+Q      Close window

UTILITIES:
  Print            Screenshot (full)
  Shift+Print      Screenshot (region)
  Mod+Print        Screenshot (window)
EOF_HELP
}
