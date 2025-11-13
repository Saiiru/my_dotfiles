# plugins focados em teclado + paleta neon
emulate -L zsh
unsetopt extendedglob bareglobqual kshglob
setopt no_nomatch

# Znap (plugin manager leve)
typeset -g ZNAP_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/znap"
[[ -d "$ZNAP_DIR" ]] || git clone --depth=1 https://github.com/marlonrichert/zsh-snap.git "$ZNAP_DIR"
source "$ZNAP_DIR/znap.zsh" 2>/dev/null || return 0

# Preferir pacotes do sistema quando existirem
if [[ -r /usr/share/zsh/plugins/zsh-completions/zsh-completions.plugin.zsh ]]; then
  source /usr/share/zsh/plugins/zsh-completions/zsh-completions.plugin.zsh
else
  znap source zsh-users/zsh-completions
fi

if [[ -r /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh ]]; then
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
else
  znap source zsh-users/zsh-autosuggestions
fi

# fzf-tab (substitui o seletor padrão de completion)
znap source Aloxaf/fzf-tab

# Paleta neon p/ zsh-syntax-highlighting (defina ANTES de carregar)
typeset -gA ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[default]=none
ZSH_HIGHLIGHT_STYLES[comment]='fg=8'
ZSH_HIGHLIGHT_STYLES[alias]='fg=cyan,bold'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=blue'
ZSH_HIGHLIGHT_STYLES[command]='fg=#39ff14,bold'      # neon green
ZSH_HIGHLIGHT_STYLES[function]='fg=magenta'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#2323FF,bold'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#9FEF00'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#9FEF00'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=yellow'

# Carregar highlighting por último e após compinit (regra oficial)
if [[ -r /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
else
  znap source zsh-users/zsh-syntax-highlighting
fi

# fzf-tab ajustes
zstyle ':fzf-tab:*' fzf-flags '--height=40%' '--layout=reverse' '--border' '--info=inline'
zstyle ':fzf-tab:*' switch-group 'Alt-h' 'Alt-l'
zstyle ':fzf-tab:complete:*' insert-unambiguous yes

# Autosuggestions: cor discreta
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'

# Widgets fzf e zoxide (se presentes)
command -v fzf >/dev/null 2>&1     && znap eval fzf    'fzf --zsh'
command -v zoxide >/dev/null 2>&1  && znap eval zoxide 'zoxide init zsh'
