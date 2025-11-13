#!/usr/bin/env bash
#═══════════════════════════════════════════════════════════════════════
# GOTHAM SYSTEM — Complete Installation
# Automated deployment of tactical development environment
#═══════════════════════════════════════════════════════════════════════

set -euo pipefail

# Colors
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly CYAN='\033[0;36m'
readonly MAGENTA='\033[0;35m'
readonly RESET='\033[0m'

# Paths
readonly GOTHAM_DIR="${HOME}/gotham"

#───────────────────────────────────────────────────────────────────────
# Logging
#───────────────────────────────────────────────────────────────────────

log_info() { echo -e "${CYAN}[INFO]${RESET} $*"; }
log_success() { echo -e "${GREEN}[SUCCESS]${RESET} $*"; }
log_warn() { echo -e "${YELLOW}[WARN]${RESET} $*"; }
log_error() { echo -e "${RED}[ERROR]${RESET} $*" >&2; }
log_step() { echo -e "\n${MAGENTA}━━━ $* ━━━${RESET}\n"; }

#───────────────────────────────────────────────────────────────────────
# Header
#───────────────────────────────────────────────────────────────────────

echo -e "${CYAN}"
cat << "HEADER"
╔══════════════════════════════════════════════════════════════╗
║            GOTHAM SYSTEM INSTALLATION                        ║
║            Tactical Development Environment                  ║
╚══════════════════════════════════════════════════════════════╝
HEADER
echo -e "${RESET}\n"

#───────────────────────────────────────────────────────────────────────
# 1. Check Dependencies
#───────────────────────────────────────────────────────────────────────

log_step "Checking dependencies"

MISSING=()
for dep in git zsh curl; do
    if command -v "$dep" &>/dev/null; then
        log_success "$dep found"
    else
        log_warn "$dep not found"
        MISSING+=("$dep")
    fi
done

if [[ ${#MISSING[@]} -gt 0 ]]; then
    log_error "Missing dependencies: ${MISSING[*]}"
    log_info "Install with: sudo pacman -S ${MISSING[*]}"
    exit 1
fi

#───────────────────────────────────────────────────────────────────────
# 2. Clone/Update Repository
#───────────────────────────────────────────────────────────────────────

log_step "Setting up Gotham repository"

if [[ -d "$GOTHAM_DIR" ]]; then
    log_warn "Directory exists. Updating..."
    cd "$GOTHAM_DIR" && git pull
else
    log_info "Cloning repository..."
    git clone https://github.com/Saiiru/my_dotfiles.git "$GOTHAM_DIR"
fi

cd "$GOTHAM_DIR"
log_success "Repository ready"

#───────────────────────────────────────────────────────────────────────
# 3. Install System Packages
#───────────────────────────────────────────────────────────────────────

log_step "Installing system packages"

packages=(
    zsh git curl wget
    kitty tmux
    eza bat fd ripgrep fzf zoxide starship
    neovim
    just
    fastfetch
)

log_info "Packages: ${packages[*]}"

if command -v pacman &>/dev/null; then
    sudo pacman -S --needed --noconfirm "${packages[@]}" || log_warn "Some packages failed"
elif command -v apt &>/dev/null; then
    sudo apt install -y "${packages[@]}" || log_warn "Some packages failed"
else
    log_warn "Package manager not found, skipping"
fi

log_success "Packages installed"

#───────────────────────────────────────────────────────────────────────
# 4. Install Mise
#───────────────────────────────────────────────────────────────────────

log_step "Installing Mise"

if ! command -v mise &>/dev/null; then
    log_info "Installing mise..."
    curl https://mise.run | sh
    export PATH="$HOME/.local/bin:$PATH"
    log_success "Mise installed"
else
    log_info "Mise already installed"
fi

#───────────────────────────────────────────────────────────────────────
# 5. Create Symlinks
#───────────────────────────────────────────────────────────────────────

log_step "Creating symlinks"

# Remove old
rm -f ~/.zshrc ~/.config/{zsh,kitty,tmux,mise,waybar,niri,wlogout,starship.toml} 2>/dev/null || true
mkdir -p ~/.config

# Create all symlinks
ln -sf "$GOTHAM_DIR/config/zsh/zshrc" "$HOME/.zshrc"
ln -sf "$GOTHAM_DIR/config/zsh" "$HOME/.config/zsh"
ln -sf "$GOTHAM_DIR/themes/starship.toml" "$HOME/.config/starship.toml"
ln -sf "$GOTHAM_DIR/config/kitty" "$HOME/.config/kitty"
ln -sf "$GOTHAM_DIR/config/tmux" "$HOME/.config/tmux"
ln -sf "$GOTHAM_DIR/config/mise" "$HOME/.config/mise"
ln -sf "$GOTHAM_DIR/config/waybar" "$HOME/.config/waybar"
ln -sf "$GOTHAM_DIR/config/niri" "$HOME/.config/niri"
ln -sf "$GOTHAM_DIR/config/wlogout" "$HOME/.config/wlogout"

log_success "Symlinks created (9 total)"

#───────────────────────────────────────────────────────────────────────
# 6. Setup Zsh
#───────────────────────────────────────────────────────────────────────

log_step "Configuring Zsh"

# Change shell
if [[ "$SHELL" != "$(which zsh)" ]]; then
    log_info "Changing default shell to Zsh..."
    chsh -s "$(which zsh)" || log_warn "Shell change requires sudo"
fi

# Create directories
mkdir -p "$HOME/.cache/zsh"
mkdir -p "$HOME/.local/state/zsh"
mkdir -p "$HOME/.local/share/zsh"

# Install znap
if [[ ! -d "$HOME/.local/share/znap" ]]; then
    log_info "Installing znap..."
    git clone --depth 1 https://github.com/marlonrichert/zsh-snap.git "$HOME/.local/share/znap"
    log_success "Znap installed"
fi

log_success "Zsh configured"

#───────────────────────────────────────────────────────────────────────
# 7. Complete
#───────────────────────────────────────────────────────────────────────

log_step "Installation Complete!"

echo -e "${GREEN}"
cat << "DONE"
╔══════════════════════════════════════════════════════════════╗
║                  GOTHAM SYSTEM READY                         ║
╚══════════════════════════════════════════════════════════════╝
DONE
echo -e "${RESET}\n"

log_success "Gotham installed successfully!"
echo ""
log_info "Next steps:"
echo ""
echo -e "  ${CYAN}exec zsh${RESET}                  # Start new shell"
echo -e "  ${CYAN}just --list${RESET}               # See all commands"
echo -e "  ${CYAN}just install-dev-tools${RESET}    # Install dev tools"
echo -e "  ${CYAN}just test${RESET}                  # Test system"
echo ""
log_success "Happy hacking! 🚀"
