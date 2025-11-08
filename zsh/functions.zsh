# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# functions.zsh — Utility functions (separate from aliases)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Create and enter directory
mkcd() {
  mkdir -p "$1" && cd "$1" || return
}

# Extract any archive
extract() {
  if [[ -f "$1" ]]; then
    case "$1" in
      *.tar.bz2)   tar xjf "$1"     ;;
      *.tar.gz)    tar xzf "$1"     ;;
      *.bz2)       bunzip2 "$1"     ;;
      *.rar)       unrar x "$1"     ;;
      *.gz)        gunzip "$1"      ;;
      *.tar)       tar xf "$1"      ;;
      *.tbz2)      tar xjf "$1"     ;;
      *.tgz)       tar xzf "$1"     ;;
      *.zip)       unzip "$1"       ;;
      *.Z)         uncompress "$1"  ;;
      *.7z)        7z x "$1"        ;;
      *)           echo "'$1' cannot be extracted" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Backup file with timestamp
backup() {
  local target="$1"
  if [[ -z "$target" ]]; then
    echo "Usage: backup <file>"
    return 1
  fi
  cp "$target" "$target.bak.$(date +%Y%m%d-%H%M%S)"
}

# Show largest files/directories
largest() {
  du -ah "${1:-.}" | sort -rh | head -n "${2:-20}"
}

# Show disk usage with duf (if available)
diskusage() {
  if command -v duf >/dev/null 2>&1; then
    duf
  else
    df -h
  fi
}

# Quick HTTP server
serve() {
  local port="${1:-8000}"
  python -m http.server "$port"
}

# Weather (wttr.in)
weather() {
  curl -s "wttr.in/${1:-FeiradeSantana}?format=v2"
}

# cheat.sh helper (renamed to avoid alias conflict)
cheatsh() {
  if [[ -z "$1" ]]; then
    echo "Usage: cheatsh <topic>"
    return 1
  fi
  curl -s "https://cheat.sh/$1"
}
