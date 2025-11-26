# Comportamento geral do shell

setopt auto_cd
setopt extended_glob
setopt correct
setopt interactive_comments
setopt no_beep
setopt notify

setopt share_history
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_expire_dups_first
setopt hist_verify

setopt prompt_subst
bindkey -e

# Não considerar / como parte da palavra (melhora navegação por palavra)
WORDCHARS=${WORDCHARS//\/}

# Evita erros de glob sem match
setopt nonomatch
