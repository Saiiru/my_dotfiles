# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# plugins.zsh — System plugins + custom enhancements
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Autosuggestions (system or manual)
if [[ -r /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
elif [[ -r "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
  source "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi
export ZSH_AUTOSUGGEST_USE_ASYNC=1
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#7C3AED,underline'

# Syntax highlighting (MUST be last)
if [[ -r /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [[ -r "$HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
  source "$HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi
