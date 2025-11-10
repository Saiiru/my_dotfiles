#!/usr/bin/env bash
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# DEPLOY ZSH DOTFILES
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
set -euo pipefail

TS=$(date +%Y%m%d-%H%M%S)
DOTFILES_DIR="$HOME/dotfiles"
ZSHRC_SRC="$DOTFILES_DIR/zsh/.zshrc"
ZSHRC_DEST="$HOME/.zshrc"

echo "🔗 Deploying ZSH configuration..."

# Backup existing .zshrc if it's a real file
if [[ -f "$ZSHRC_DEST" && ! -L "$ZSHRC_DEST" ]]; then
    echo "  -> Backing up existing .zshrc to ${ZSHRC_DEST}.bak.${TS}"
    mv "$ZSHRC_DEST" "${ZSHRC_DEST}.bak.${TS}"
fi

# Create the symlink
ln -sfn "$ZSHRC_SRC" "$ZSHRC_DEST"
echo "  -> Symlink created: $ZSHRC_SRC -> $ZSHRC_DEST"

echo ""
echo "✅ Deployment complete!"
echo "Run 'exec zsh' to start your new shell."
