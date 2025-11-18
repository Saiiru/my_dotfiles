#═══════════════════════════════════════════════════════════════════════
# WORKSTATION OPS — Just Task Runner
#═══════════════════════════════════════════════════════════════════════

set shell := ["zsh", "-cu"]

context_bin := if env_var_or_default("NEON_CONTEXT_SWITCH", "") != "" { env_var_or_default("NEON_CONTEXT_SWITCH", "") } else { env_var("HOME") + "/.local/bin/context-switch" }
neon_state_dir := if env_var_or_default("XDG_STATE_HOME", "") != "" { env_var_or_default("XDG_STATE_HOME", "") } else { env_var("HOME") + "/.local/state" }

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

#───────────────────────────────────────────────────────────────────────
# 🎮 NEON-NIRI Context & Gaming Stack
#───────────────────────────────────────────────────────────────────────

context-status:
    @{{context_bin}} status

context-default:
    @{{context_bin}} default

context-dev:
    @{{context_bin}} dev

context-game:
    @{{context_bin}} game

context-log:
    @tail -n 40 {{neon_state_dir}}/neon-niri/context-switch.log || true

neon-setup: install context-default
    @echo "✅ NEON-NIRI base profile applied"

neon-update: symlink install-dev-tools context-status
    @echo "🔄 NEON stack refreshed"
