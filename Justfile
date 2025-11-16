#═══════════════════════════════════════════════════════════════════════
# WORKSTATION OPS — Just Task Runner
#═══════════════════════════════════════════════════════════════════════

set shell := ["zsh", "-cu"]

default:
    @just --list --unsorted

#───────────────────────────────────────────────────────────────────────
# 🚀 Installation & Setup
#───────────────────────────────────────────────────────────────────────

install:
    @echo "🚀 Installing workstation..."
    ./install/install.sh

symlink:
    @echo "🔗 Refreshing symlinks..."
    ./install/symlinks-only.sh

reinstall:
    just clean
    just install

#───────────────────────────────────────────────────────────────────────
# 📦 Toolchains
#───────────────────────────────────────────────────────────────────────

install-dev-tools:
    @echo "🛠️  Installing mise toolchains..."
    mise install

update-dev-tools:
    @echo "🔄 Updating mise toolchains..."
    mise upgrade

list-tools:
    @echo "📋 Installed tools:"
    mise list

#───────────────────────────────────────────────────────────────────────
# 🧹 Maintenance
#───────────────────────────────────────────────────────────────────────

clean:
    @echo "🧹 Cleaning shell caches..."
    rm -rf ~/.cache/zsh/*
    rm -f ~/.zcompdump*
    rm -f ~/.zshrc.zwc
    find config/zsh -name '*.zwc' -delete
    @echo "✅ Cache cleaned"

reload:
    @echo "🔄 Reloading shell configuration..."
    exec zsh

#───────────────────────────────────────────────────────────────────────
# 🩺 Validation
#───────────────────────────────────────────────────────────────────────

test:
    @echo "🧪 Running workstation health check..."
    ./test-complete-setup.sh

health:
    just test

info:
    @echo "WORKSTATION OPS INFO"
    @echo "Root    : ${WORKSTATION_DIR:-$HOME/workstation}"
    @echo "Config  : ${WORKSTATION_DIR:-$HOME/workstation}/config"
    @echo "Install : ${WORKSTATION_DIR:-$HOME/workstation}/install/install.sh"
