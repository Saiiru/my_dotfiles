# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# posh-init.zsh — Oh-My-Posh KORA Neon theme loader
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

if ! command -v oh-my-posh >/dev/null; then
  # Fallback minimal prompt
  PROMPT='%F{#22D3EE}❯%f '
  return
fi

OMP_THEME="$ZDOTDIR/prompt/posh.json"
if [[ -f "$OMP_THEME" ]]; then
  eval "$(oh-my-posh init zsh --config "$OMP_THEME")"
else
  echo "⚠ Oh-My-Posh theme not found: $OMP_THEME"
fi
