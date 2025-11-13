#!/usr/bin/env bash
#═══════════════════════════════════════════════════════════════════════
# GOTHAM SYSTEM — Symlink Manager
# Criação e validação automática de todos os symlinks do sistema
#═══════════════════════════════════════════════════════════════════════

set -euo pipefail

# Colors
readonly COLOR_SUCCESS='\033[1;32m'
readonly COLOR_ERROR='\033[1;31m'
readonly COLOR_WARN='\033[1;33m'
readonly COLOR_INFO='\033[1;36m'
readonly COLOR_RESET='\033[0m'

ERRORS=0
CREATED=0
SKIPPED=0

#───────────────────────────────────────────────────────────────────────
# Logging
#───────────────────────────────────────────────────────────────────────

log_success() {
    echo -e "${COLOR_SUCCESS}[✓]${COLOR_RESET} $*"
}

log_error() {
    ((ERRORS++))
    echo -e "${COLOR_ERROR}[✗]${COLOR_RESET} $*" >&2
}

log_warn() {
    echo -e "${COLOR_WARN}[⚠]${COLOR_RESET} $*"
}

log_info() {
    echo -e "${COLOR_INFO}[ℹ]${COLOR_RESET} $*"
}

#───────────────────────────────────────────────────────────────────────
# Create Symlink Function
#───────────────────────────────────────────────────────────────────────

create_symlink() {
    local source="$1"
    local target="$2"
    local description="${3:-}"
    
    # Verifica se source existe
    if [[ ! -e "$source" ]]; then
        log_error "Source missing: $source"
        return 1
    fi
    
    # Se target já existe e é um symlink válido, skip
    if [[ -L "$target" ]]; then
        local current_source=$(readlink -f "$target")
        local expected_source=$(readlink -f "$source")
        
        if [[ "$current_source" == "$expected_source" ]]; then
            log_info "Already linked: $target → $source"
            ((SKIPPED++)) || true
            return 0
        else
            log_warn "Incorrect link: $target → $current_source (expected: $source)"
            rm "$target"
        fi
    elif [[ -e "$target" ]]; then
        log_warn "File exists (not symlink): $target"
        mv "$target" "${target}.bak.$(date +%s)"
        log_info "Backed up to: ${target}.bak.$(date +%s)"
    fi
    
    # Cria diretório pai se necessário
    local parent_dir=$(dirname "$target")
    [[ -d "$parent_dir" ]] || mkdir -p "$parent_dir"
    
    # Cria symlink
    if ln -sf "$source" "$target"; then
        log_success "Created: $target → $source${description:+ ($description)}"
        ((CREATED++)) || true
    else
        log_error "Failed to create: $target"
        return 1
    fi
}

#───────────────────────────────────────────────────────────────────────
# Header
#───────────────────────────────────────────────────────────────────────

echo -e "${COLOR_INFO}"
cat << "EOF"
╔══════════════════════════════════════════════════════════════╗
║            GOTHAM SYSTEM SYMLINK MANAGER                     ║
║            Automated Link Creation & Validation              ║
╚══════════════════════════════════════════════════════════════╝
EOF
echo -e "${COLOR_RESET}\n"

#───────────────────────────────────────────────────────────────────────
# Define all symlinks
#───────────────────────────────────────────────────────────────────────

GOTHAM_DIR="${GOTHAM_DIR:-$HOME/gotham}"

declare -A SYMLINKS=(
    # Zsh
    ["$GOTHAM_DIR/config/zsh/zshrc"]="$HOME/.zshrc"
    ["$GOTHAM_DIR/config/zsh"]="$HOME/.config/zsh"
    
    # Starship
    ["$GOTHAM_DIR/themes/starship.toml"]="$HOME/.config/starship.toml"
    
    # Kitty
    ["$GOTHAM_DIR/config/kitty"]="$HOME/.config/kitty"
    
    # Tmux
    ["$GOTHAM_DIR/config/tmux"]="$HOME/.config/tmux"
    
    # Mise
    ["$GOTHAM_DIR/config/mise"]="$HOME/.config/mise"
    
    # Waybar
    ["$GOTHAM_DIR/config/waybar"]="$HOME/.config/waybar"
    
    # Niri
    ["$GOTHAM_DIR/config/niri"]="$HOME/.config/niri"
    
    # Wlogout
    ["$GOTHAM_DIR/config/wlogout"]="$HOME/.config/wlogout"
)

#───────────────────────────────────────────────────────────────────────
# Create symlinks
#───────────────────────────────────────────────────────────────────────

log_info "Creating symlinks...\n"

for source in "${!SYMLINKS[@]}"; do
    target="${SYMLINKS[$source]}"
    create_symlink "$source" "$target"
done

#───────────────────────────────────────────────────────────────────────
# Summary
#───────────────────────────────────────────────────────────────────────

echo
echo -e "${COLOR_INFO}═══════════════════════════════════════════════════${COLOR_RESET}"
echo -e "${COLOR_INFO}                  SUMMARY                          ${COLOR_RESET}"
echo -e "${COLOR_INFO}═══════════════════════════════════════════════════${COLOR_RESET}"
echo -e "Created:  ${COLOR_SUCCESS}${CREATED}${COLOR_RESET}"
echo -e "Skipped:  ${COLOR_INFO}${SKIPPED}${COLOR_RESET}"
echo -e "Errors:   ${COLOR_ERROR}${ERRORS}${COLOR_RESET}"
echo

if [[ $ERRORS -eq 0 ]]; then
    log_success "All symlinks configured successfully!"
    exit 0
else
    log_error "Failed to create some symlinks"
    exit 1
fi
