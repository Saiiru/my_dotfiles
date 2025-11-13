#!/usr/bin/env bash
#═══════════════════════════════════════════════════════════════════════
# GOTHAM SYSTEM — Bootstrap Installation
# Automated deployment of tactical development environment
#═══════════════════════════════════════════════════════════════════════

set -euo pipefail

# Colors
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly MAGENTA='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly RESET='\033[0m'

# Paths
readonly GOTHAM_DIR="${HOME}/gotham"
readonly BACKUP_DIR="${HOME}/.gotham.backup.$(date +%Y%m%d_%H%M%S)"

#───────────────────────────────────────────────────────────────────────
# Logging
#───────────────────────────────────────────────────────────────────────

log_info() {
    echo -e "${CYAN}[INFO]${RESET} $*"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${RESET} $*"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${RESET} $*"
}

log_error() {
    echo -e "${RED}[ERROR]${RESET} $*" >&2
}

log_step() {
    echo -e "\n${MAGENTA}━━━ $* ━━━${RESET}\n"
}

#───────────────────────────────────────────────────────────────────────
# Dependency Check
#───────────────────────────────────────────────────────────────────────

check_dependencies() {
    local deps=(git curl zsh)
    local missing=()
    
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &>/dev/null; then
            missing+=("$dep")
        fi
    done
    
    if [[ ${#missing[@]} -gt 0 ]]; then
        log_error "Missing dependencies: ${missing[*]}"
        log_info "Install with: sudo pacman -S ${missing[*]}"
        exit 1
    fi
}

#───────────────────────────────────────────────────────────────────────
# Backup Existing Config
#───────────────────────────────────────────────────────────────────────

backup_existing() {
    log_step "Creating backup"
    
    mkdir -p "$BACKUP_DIR"
    
    local configs=(
        "$HOME/.zshrc"
        "$HOME/.config/zsh"
        "$HOME/.config/kitty"
        "$HOME/.config/tmux"
        "$HOME/.config/mise"
    )
    
    for config in "${configs[@]}"; do
        if [[ -e "$config" ]]; then
            cp -r "$config" "$BACKUP_DIR/"
            log_info "Backed up: $config"
        fi
    done
    
    log_success "Backup created: $BACKUP_DIR"
}

#───────────────────────────────────────────────────────────────────────
# Clone Repository
#───────────────────────────────────────────────────────────────────────

clone_gotham() {
    log_step "Cloning Gotham repository"
    
    if [[ -d "$GOTHAM_DIR" ]]; then
        log_warn "Directory exists. Updating..."
        cd "$GOTHAM_DIR" && git pull
    else
        git clone https://github.com/YOUR_USERNAME/gotham.git "$GOTHAM_DIR"
    fi
    
    cd "$GOTHAM_DIR"
    log_success "Repository ready"
}

#───────────────────────────────────────────────────────────────────────
# Install System Packages
#───────────────────────────────────────────────────────────────────────

install_packages() {
    log_step "Installing system packages"
    
    local packages=(
        # Core
        zsh git curl wget
        # Terminal
        kitty tmux
        # Modern tools
        eza bat fd ripgrep fzf zoxide starship
        # Development
        neovim
        # Mise (toolchain manager)
        # Task (task manager)
        just
        # Optional
        fastfetch
    )
    
    log_info "Installing: ${packages[*]}"
    sudo pacman -S --needed --noconfirm "${packages[@]}"
    
    log_success "Packages installed"
}

#───────────────────────────────────────────────────────────────────────
# Install Mise
#───────────────────────────────────────────────────────────────────────

install_mise() {
    log_step "Installing Mise"
    
    if ! command -v mise &>/dev/null; then
        curl https://mise.run | sh
        export PATH="$HOME/.local/bin:$PATH"
    fi
    
    log_success "Mise installed"
}

#───────────────────────────────────────────────────────────────────────
# Create Symlinks
#───────────────────────────────────────────────────────────────────────

create_symlinks() {
    log_step "Creating symlinks"
    
    # Zsh
    ln -sf "$GOTHAM_DIR/config/zsh/zshrc" "$HOME/.zshrc"
    ln -sf "$GOTHAM_DIR/config/zsh" "$HOME/.config/zsh"
    
    # Kitty
    mkdir -p "$HOME/.config/kitty"
    ln -sf "$GOTHAM_DIR/config/kitty/kitty.conf" "$HOME/.config/kitty/kitty.conf"
    
    # Tmux
    mkdir -p "$HOME/.config/tmux"
    ln -sf "$GOTHAM_DIR/config/tmux/tmux.conf" "$HOME/.config/tmux/tmux.conf"
    
    # Mise
    mkdir -p "$HOME/.config/mise"
    ln -sf "$GOTHAM_DIR/config/mise/config.toml" "$HOME/.config/mise/config.toml"
    
    # Starship
    ln -sf "$GOTHAM_DIR/themes/starship.toml" "$HOME/.config/starship.toml"
    
    log_success "Symlinks created"
}

#───────────────────────────────────────────────────────────────────────
# Setup Zsh
#───────────────────────────────────────────────────────────────────────

setup_zsh() {
    log_step "Configuring Zsh"
    
    # Change default shell
    if [[ "$SHELL" != "$(which zsh)" ]]; then
        chsh -s "$(which zsh)"
        log_info "Default shell changed to Zsh"
    fi
    
    # Create necessary directories
    mkdir -p "$HOME/.cache/zsh"
    mkdir -p "$HOME/.local/state/zsh"
    mkdir -p "$HOME/.local/share/zsh"
    
    log_success "Zsh configured"
}

#───────────────────────────────────────────────────────────────────────
# Install Tmux Plugin Manager
#───────────────────────────────────────────────────────────────────────

setup_tmux() {
    log_step "Setting up Tmux"
    
    if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
        git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
        log_info "TPM installed"
    fi
    
    log_success "Tmux configured"
}

#───────────────────────────────────────────────────────────────────────
# Install Global Tools via Mise
#───────────────────────────────────────────────────────────────────────

install_global_tools() {
    log_step "Installing global tools"
    
    mise install
    
    log_success "Global tools installed"
}

#───────────────────────────────────────────────────────────────────────
# Final Steps
#───────────────────────────────────────────────────────────────────────

final_steps() {
    log_step "Final configuration"
    
    # Compile zsh files
    for file in "$HOME/.config/zsh"/**/*.zsh; do
        zcompile "$file" 2>/dev/null || true
    done
    
    log_success "Installation complete!"
    
    echo -e "\n${GREEN}╔══════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${GREEN}║             GOTHAM SYSTEM OPERATIONAL                        ║${RESET}"
    echo -e "${GREEN}╠══════════════════════════════════════════════════════════════╣${RESET}"
    echo -e "${GREEN}║  Next steps:                                                 ║${RESET}"
    echo -e "${GREEN}║  1. Logout/login or run: exec zsh                           ║${RESET}"
    echo -e "${GREEN}║  2. In tmux: Prefix + I (install plugins)                   ║${RESET}"
    echo -e "${GREEN}║  3. Run: just health                                         ║${RESET}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${RESET}\n"
}

#───────────────────────────────────────────────────────────────────────
# Main
#───────────────────────────────────────────────────────────────────────

main() {
    echo -e "${CYAN}"
    cat << "EOF"
    ╔═══════════════════════════════════════════════════════════╗
    ║                                                           ║
    ║   ██████╗  ██████╗ ████████╗██╗  ██╗ █████╗ ███╗   ███╗ ║
    ║  ██╔════╝ ██╔═══██╗╚══██╔══╝██║  ██║██╔══██╗████╗ ████║ ║
    ║  ██║  ███╗██║   ██║   ██║   ███████║███████║██╔████╔██║ ║
    ║  ██║   ██║██║   ██║   ██║   ██╔══██║██╔══██║██║╚██╔╝██║ ║
    ║  ╚██████╔╝╚██████╔╝   ██║   ██║  ██║██║  ██║██║ ╚═╝ ██║ ║
    ║   ╚═════╝  ╚═════╝    ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝ ║
    ║                                                           ║
    ║             Tactical Development Environment             ║
    ║                                                           ║
    ╚═══════════════════════════════════════════════════════════╝
EOF
    echo -e "${RESET}\n"
    
    check_dependencies
    backup_existing
    clone_gotham
    install_packages
    install_mise
    create_symlinks
    setup_zsh
    setup_tmux
    install_global_tools
    final_steps
}

main "$@"
