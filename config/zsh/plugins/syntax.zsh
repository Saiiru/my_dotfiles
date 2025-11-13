#!/usr/bin/env zsh
#═══════════════════════════════════════════════════════════════════════
# GOTHAM SYSTEM — Syntax Highlighting
# Sistema de colorização de sintaxe (SEMPRE POR ÚLTIMO)
#═══════════════════════════════════════════════════════════════════════

# Preferir versão do sistema
if [[ -r /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
else
    znap source zsh-users/zsh-syntax-highlighting
fi

#───────────────────────────────────────────────────────────────────────
# NEON VIGILANTE THEME
#───────────────────────────────────────────────────────────────────────

typeset -gA ZSH_HIGHLIGHT_STYLES

ZSH_HIGHLIGHT_STYLES[default]=none
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red,bold'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=magenta,bold'
ZSH_HIGHLIGHT_STYLES[alias]='fg=cyan,bold'
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=cyan,bold'
ZSH_HIGHLIGHT_STYLES[global-alias]='fg=cyan,bold'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=blue,bold'
ZSH_HIGHLIGHT_STYLES[function]='fg=magenta,bold'
ZSH_HIGHLIGHT_STYLES[command]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=green,underline'
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=green'
ZSH_HIGHLIGHT_STYLES[path]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[path_pathseparator]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=cyan,underline'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=blue,bold'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[back-or-dollar-double-quoted-argument]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=magenta,bold'
ZSH_HIGHLIGHT_STYLES[comment]='fg=black,bold'
ZSH_HIGHLIGHT_STYLES[assign]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[variable]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[bracket-level-1]='fg=yellow,bold'
ZSH_HIGHLIGHT_STYLES[bracket-level-2]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[bracket-level-3]='fg=magenta,bold'
ZSH_HIGHLIGHT_STYLES[cursor]='bg=blue'

# Performance
ZSH_HIGHLIGHT_MAXLENGTH=512
