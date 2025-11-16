#!/usr/bin/env bash
#═══════════════════════════════════════════════════════════════════════
# WORKSTATION OPS — Complete Installation
# Automated deployment of the workstation environment
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
readonly SCRIPT_DIR="$(cd -- "$(dirname "$0")" && pwd)"
readonly WORKSTATION_DIR="$(cd -- "$SCRIPT_DIR/.." && pwd)"
readonly MODULE_DIR="$SCRIPT_DIR/modules"

source "$MODULE_DIR/packages.sh"
source "$MODULE_DIR/mise.sh"
source "$MODULE_DIR/symlinks.sh"
source "$MODULE_DIR/tmux.sh"
source "$MODULE_DIR/zsh.sh"

#───────────────────────────────────────────────────────────────────────
# Logging helpers
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
║            WORKSTATION OPS INSTALLER                         ║
║            Tactical Development Environment                  ║
╚══════════════════════════════════════════════════════════════╝
HEADER
echo -e "${RESET}\n"
log_info "Repository root: $WORKSTATION_DIR"

#───────────────────────────────────────────────────────────────────────
# 1. Check Dependencies
#───────────────────────────────────────────────────────────────────────

log_step "Checking dependencies"

missing=()
for dep in git zsh curl; do
    if command -v "$dep" &>/dev/null; then
        log_success "$dep found"
    else
        log_warn "$dep not found"
        missing+=("$dep")
    fi
done

if [[ ${#missing[@]} -gt 0 ]]; then
    log_error "Missing dependencies: ${missing[*]}"
    log_info "Install with: sudo pacman -S ${missing[*]}"
    exit 1
fi

#───────────────────────────────────────────────────────────────────────
# 2. Install System Packages
#───────────────────────────────────────────────────────────────────────

log_step "Installing base packages"
install_core_packages
log_success "Packages installed"

#───────────────────────────────────────────────────────────────────────
# 3. Install Mise
#───────────────────────────────────────────────────────────────────────

log_step "Installing Mise"
install_mise
log_success "Mise configured"

#───────────────────────────────────────────────────────────────────────
# 4. Create Symlinks
#───────────────────────────────────────────────────────────────────────

log_step "Creating symlinks"
create_symlinks "$WORKSTATION_DIR"
log_success "Symlinks created"

#───────────────────────────────────────────────────────────────────────
# 5. Configure Shell & Tooling
#───────────────────────────────────────────────────────────────────────

log_step "Configuring shell"
configure_zsh
log_success "Zsh configured"

log_step "Ensuring tmux plugins"
setup_tmux_plugins
log_success "Tmux TPM ready"

#───────────────────────────────────────────────────────────────────────
# 6. Complete
#───────────────────────────────────────────────────────────────────────

log_step "Installation Complete!"

echo -e "${GREEN}"
cat << "DONE"
╔══════════════════════════════════════════════════════════════╗
║                  WORKSTATION READY                           ║
╚══════════════════════════════════════════════════════════════╝
DONE
echo -e "${RESET}\n"

log_success "Workstation installed successfully!"
echo ""
log_info "Next steps:"
echo ""
echo -e "  ${CYAN}exec zsh${RESET}                  # Start new shell"
echo -e "  ${CYAN}just --list${RESET}               # Explore commands"
echo -e "  ${CYAN}just install-dev-tools${RESET}    # Install dev toolchains"
echo -e "  ${CYAN}just test${RESET}                  # Validate setup"
echo ""
log_success "Happy hacking! 🚀"
