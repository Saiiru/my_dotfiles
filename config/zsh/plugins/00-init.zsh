#!/usr/bin/env zsh
#═══════════════════════════════════════════════════════════════════════
# WORKSTATION OPS — Plugin Manager Initialization
# Setup znap plugin manager
#═══════════════════════════════════════════════════════════════════════

# Znap plugin manager location (XDG compliant)
export ZNAP_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/znap"

# Install znap if not present
if [[ ! -d "$ZNAP_DIR" ]]; then
    echo "📦 Installing znap plugin manager..."
    mkdir -p "$ZNAP_DIR"
    git clone --depth 1 https://github.com/marlonrichert/zsh-snap.git "$ZNAP_DIR" 2>/dev/null
fi

# Source znap
if [[ -f "$ZNAP_DIR/znap.zsh" ]]; then
    source "$ZNAP_DIR/znap.zsh"
else
    # Fallback: manual loading without znap
    echo "⚠️  Znap not found, using direct loading"
    
    # Define znap eval fallback
    znap() {
        case "$1" in
            eval)
                shift
                local cmd="$2"
                eval "$($cmd)"
                ;;
            source)
                shift
                source "$@"
                ;;
            *)
                echo "znap: unknown command '$1'"
                ;;
        esac
    }
fi
