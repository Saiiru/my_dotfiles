#!/usr/bin/env zsh
#═══════════════════════════════════════════════════════════════════════
# GOTHAM SYSTEM — Environment Configuration
# PATH construction, XDG compliance, global variables
# VERSION: 2.0 (com sistema de logging integrado)
#═══════════════════════════════════════════════════════════════════════

#───────────────────────────────────────────────────────────────────────
# COLOR SYSTEM (Semantic Colors)
#───────────────────────────────────────────────────────────────────────

# ANSI escape codes para cores consistentes
export COLOR_RESET='\033[0m'

# Success states (Verde)
export COLOR_SUCCESS='\033[0;32m'       # Verde normal
export COLOR_SUCCESS_BOLD='\033[1;32m'  # Verde bold

# Error states (Vermelho)
export COLOR_ERROR='\033[0;31m'         # Vermelho normal
export COLOR_ERROR_BOLD='\033[1;31m'    # Vermelho bold

# Warning states (Amarelo)
export COLOR_WARN='\033[0;33m'          # Amarelo normal
export COLOR_WARN_BOLD='\033[1;33m'     # Amarelo bold

# Info states (Cyan)
export COLOR_INFO='\033[0;36m'          # Cyan normal
export COLOR_INFO_BOLD='\033[1;36m'     # Cyan bold

# Debug states (Magenta)
export COLOR_DEBUG='\033[0;35m'         # Magenta normal
export COLOR_DEBUG_BOLD='\033[1;35m'    # Magenta bold

# Special (Branco/Cinza)
export COLOR_WHITE='\033[0;37m'
export COLOR_GRAY='\033[0;90m'

#───────────────────────────────────────────────────────────────────────
# LOGGING FUNCTIONS
#───────────────────────────────────────────────────────────────────────

# Log file
export GOTHAM_LOG_FILE="${XDG_STATE_HOME:-$HOME/.local/state}/gotham/shell.log"
[[ -d "$(dirname "$GOTHAM_LOG_FILE")" ]] || mkdir -p "$(dirname "$GOTHAM_LOG_FILE")"

# Logging functions
log_success() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo -e "${COLOR_SUCCESS_BOLD}[✓]${COLOR_RESET} $*"
    echo "[$timestamp] [SUCCESS] $*" >> "$GOTHAM_LOG_FILE"
}

log_error() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo -e "${COLOR_ERROR_BOLD}[✗]${COLOR_RESET} $*" >&2
    echo "[$timestamp] [ERROR] $*" >> "$GOTHAM_LOG_FILE"
}

log_warn() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo -e "${COLOR_WARN_BOLD}[⚠]${COLOR_RESET} $*"
    echo "[$timestamp] [WARN] $*" >> "$GOTHAM_LOG_FILE"
}

log_info() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo -e "${COLOR_INFO_BOLD}[ℹ]${COLOR_RESET} $*"
    echo "[$timestamp] [INFO] $*" >> "$GOTHAM_LOG_FILE"
}

log_debug() {
    [[ -n "$GOTHAM_DEBUG" ]] || return 0
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo -e "${COLOR_DEBUG}[DEBUG]${COLOR_RESET} $*"
    echo "[$timestamp] [DEBUG] $*" >> "$GOTHAM_LOG_FILE"
}

#───────────────────────────────────────────────────────────────────────
# XDG Base Directory Specification
#───────────────────────────────────────────────────────────────────────

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

log_debug "XDG directories initialized"

#───────────────────────────────────────────────────────────────────────
# Project Directories
#───────────────────────────────────────────────────────────────────────

export GOTHAM_DIR="$HOME/gotham"
export PROJECTS_DIR="$HOME/projects"
export WORKSPACE_DIR="$HOME/workspace"

# Validate Gotham directory
if [[ ! -d "$GOTHAM_DIR" ]]; then
    log_error "Gotham directory not found: $GOTHAM_DIR"
else
    log_debug "Gotham directory: $GOTHAM_DIR"
fi

#───────────────────────────────────────────────────────────────────────
# STARSHIP CONFIG (CRÍTICO: ANTES DO INIT!)
#───────────────────────────────────────────────────────────────────────

export STARSHIP_CONFIG="$GOTHAM_DIR/themes/starship.toml"

if [[ ! -f "$STARSHIP_CONFIG" ]]; then
    log_error "Starship config not found: $STARSHIP_CONFIG"
else
    log_debug "Starship config: $STARSHIP_CONFIG"
fi

#───────────────────────────────────────────────────────────────────────
# Editor Configuration
#───────────────────────────────────────────────────────────────────────

export EDITOR="nvim"
export VISUAL="nvim"
export SUDO_EDITOR="nvim"
export PAGER="less"
export LESS="-R -F -X -i --mouse"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# Validate editor
if ! command -v "$EDITOR" >/dev/null 2>&1; then
    log_warn "Editor not found: $EDITOR"
    export EDITOR="vi"
fi

#───────────────────────────────────────────────────────────────────────
# Locale
#───────────────────────────────────────────────────────────────────────

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

#───────────────────────────────────────────────────────────────────────
# Terminal
#───────────────────────────────────────────────────────────────────────

export TERM="xterm-256color"
export COLORTERM="truecolor"

#───────────────────────────────────────────────────────────────────────
# PATH Construction
#───────────────────────────────────────────────────────────────────────

typeset -U path

path=(
    $HOME/.local/bin
    $GOTHAM_DIR/bin/system
    $GOTHAM_DIR/bin/battery
    $GOTHAM_DIR/bin/theme
    $HOME/.local/share/mise/shims
    $HOME/.local/share/mise/installs/*/bin(N)
    $HOME/.cargo/bin
    $HOME/.go/bin(N)
    /usr/local/sbin
    /usr/local/bin
    /usr/bin
    /usr/sbin
    /sbin
    /bin
    /usr/lib/jvm/default/bin(N)
    $path
)

path=($^path(N-/))
export PATH

log_debug "PATH configured: ${#path} entries"

#───────────────────────────────────────────────────────────────────────
# FZF Configuration
#───────────────────────────────────────────────────────────────────────

export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS="
--height=60%
--layout=reverse
--border=rounded
--prompt='❯ '
--pointer='▶'
--marker='✓'
--color=fg:#00ff00,bg:#000000,hl:#ff073a
--color=fg+:#00ffff,bg+:#1a1a1a,hl+:#ff073a
--color=info:#00ffff,prompt:#00ff00,pointer:#ff073a
--color=marker:#00ff00,spinner:#00ffff,header:#ff00ff
--color=border:#ff073a
--bind='ctrl-/:toggle-preview'
--bind='ctrl-u:preview-half-page-up'
--bind='ctrl-d:preview-half-page-down'
--bind='alt-a:select-all'
--bind='alt-d:deselect-all'
"

export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers {}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --level=2 --icons --color=always {}'"

#───────────────────────────────────────────────────────────────────────
# Tool Configurations
#───────────────────────────────────────────────────────────────────────

# Zoxide
export _ZO_ECHO=1
export _ZO_RESOLVE_SYMLINKS=1

# Bat
export BAT_THEME="base16"
export BAT_STYLE="numbers,changes,header"

# Eza
export EZA_COLORS="da=38;5;8:di=38;5;81"

# Mise
export MISE_DATA_DIR="$XDG_DATA_HOME/mise"
export MISE_CONFIG_DIR="$XDG_CONFIG_HOME/mise"
export MISE_CACHE_DIR="$XDG_CACHE_HOME/mise"
export MISE_AUTO_INSTALL=0
export MISE_PYTHON_COMPILE=0
export MISE_NODE_COMPILE=0

# Go
export GOPATH="$HOME/.go"
export GOMODCACHE="$XDG_CACHE_HOME/go/mod"
export GOCACHE="$XDG_CACHE_HOME/go/build"

# Python
export WORKON_HOME="$XDG_DATA_HOME/virtualenvs"
export PIPX_HOME="$XDG_DATA_HOME/pipx"
export PIPX_BIN_DIR="$HOME/.local/bin"

# Node
export NODE_OPTIONS="--max-old-space-size=4096"
export NPM_CONFIG_PREFIX="$HOME/.npm-global"
export PNPM_HOME="$XDG_DATA_HOME/pnpm"

# Rust
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export CARGO_HOME="$XDG_DATA_HOME/cargo"

# Docker
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"

# Kubernetes
export KUBECONFIG="$XDG_CONFIG_HOME/kube/config"

#npm
export NPM_CONFIG_PREFIX="$HOME/.npm-global"
export PATH="$HOME/.npm-global/bin:$PATH"
#───────────────────────────────────────────────────────────────────────
# Performance Optimization
#───────────────────────────────────────────────────────────────────────

skip_global_compinit=1

log_debug "Environment configuration loaded successfully"
