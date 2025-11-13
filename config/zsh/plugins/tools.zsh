#!/usr/bin/env zsh
#═══════════════════════════════════════════════════════════════════════
# GOTHAM SYSTEM — Tool Integrations
# Integração de ferramentas modernas
#═══════════════════════════════════════════════════════════════════════

#───────────────────────────────────────────────────────────────────────
# FZF (Fuzzy Finder)
#───────────────────────────────────────────────────────────────────────

if command -v fzf >/dev/null 2>&1; then
    znap eval fzf 'fzf --zsh'
fi

#───────────────────────────────────────────────────────────────────────
# ZOXIDE (Smart CD)
#───────────────────────────────────────────────────────────────────────

if command -v zoxide >/dev/null 2>&1; then
    znap eval zoxide 'zoxide init zsh'
    alias cd='z'
    alias cdi='zi'
fi

#───────────────────────────────────────────────────────────────────────
# MISE (Toolchain Manager)
#───────────────────────────────────────────────────────────────────────

if command -v mise >/dev/null 2>&1; then
    znap eval mise 'mise activate zsh'
fi

#───────────────────────────────────────────────────────────────────────
# DIRENV (Per-directory Environments)
#───────────────────────────────────────────────────────────────────────

if command -v direnv >/dev/null 2>&1; then
    znap eval direnv 'direnv hook zsh'
fi

#───────────────────────────────────────────────────────────────────────
# STARSHIP (Prompt)
#───────────────────────────────────────────────────────────────────────

if command -v starship >/dev/null 2>&1; then
    export STARSHIP_CONFIG="$GOTHAM_DIR/shell/starship.toml"
    znap eval starship 'starship init zsh --print-full-init'
fi

#───────────────────────────────────────────────────────────────────────
# THEFUCK (Command Correction - Lazy Load)
#───────────────────────────────────────────────────────────────────────

if command -v thefuck >/dev/null 2>&1; then
    fuck() {
        unfunction fuck 2>/dev/null
        eval "$(thefuck --alias)"
        fuck "$@"
    }
    alias fk='fuck'
fi
