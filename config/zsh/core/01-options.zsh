#!/usr/bin/env zsh
# -----------------------------------------------------------------------------
# Gotham Shell · Core options
# -----------------------------------------------------------------------------
# Curated `setopt`/`unsetopt` directives for interactive shells. These values
# favour predictable navigation, completion and history behaviour. Adjust with
# caution and keep the grouping documented.
# -----------------------------------------------------------------------------

# --- Navigation --------------------------------------------------------------

setopt AUTO_CD                  # cd digitando apenas nome do diretório
setopt AUTO_PUSHD               # cd adiciona ao stack automaticamente
setopt PUSHD_IGNORE_DUPS        # Remove duplicatas do stack
setopt PUSHD_SILENT             # Não imprime stack
setopt PUSHD_TO_HOME            # pushd sem args vai para $HOME
setopt CDABLE_VARS              # cd para variáveis

# --- Completion --------------------------------------------------------------

setopt ALWAYS_TO_END            # Cursor vai ao fim após completion
setopt AUTO_LIST                # Lista opções automaticamente
setopt AUTO_MENU                # Menu após segundo TAB
setopt AUTO_PARAM_SLASH         # Adiciona / após diretórios
setopt COMPLETE_IN_WORD         # Completa do meio da palavra
setopt LIST_PACKED              # Usa menos linhas
setopt MENU_COMPLETE            # Insere primeira opção automaticamente
unsetopt FLOW_CONTROL           # Desabilita Ctrl+S/Ctrl+Q

# --- History -----------------------------------------------------------------

setopt EXTENDED_HISTORY          # Salva timestamp
setopt HIST_EXPIRE_DUPS_FIRST    # Expira duplicatas primeiro
setopt HIST_FIND_NO_DUPS         # Busca não mostra duplicatas
setopt HIST_IGNORE_ALL_DUPS      # Ignora TODAS as duplicatas
setopt HIST_IGNORE_DUPS          # Ignora duplicatas consecutivas
setopt HIST_IGNORE_SPACE         # Ignora comandos com espaço inicial
setopt HIST_REDUCE_BLANKS        # Remove espaços extras
setopt HIST_SAVE_NO_DUPS         # Não salva duplicatas
setopt HIST_VERIFY               # Não executa imediatamente expansão
setopt INC_APPEND_HISTORY        # Adiciona imediatamente
setopt SHARE_HISTORY             # Compartilha entre sessões

# --- Correction --------------------------------------------------------------

unsetopt CORRECT                 # Desabilita correção automática
unsetopt CORRECT_ALL

# --- Globbing ----------------------------------------------------------------

setopt EXTENDED_GLOB             # Padrões avançados
setopt GLOB_DOTS                 # Inclui arquivos ocultos
setopt NO_NOMATCH                # Não erro se glob não encontrar
setopt NUMERIC_GLOB_SORT         # Ordena numericamente

# --- Jobs --------------------------------------------------------------------

setopt AUTO_RESUME               # Resume job suspenso
setopt LONG_LIST_JOBS            # Lista jobs com mais info
setopt NO_BG_NICE                # Não diminui prioridade
setopt NO_CHECK_JOBS             # Não avisa sobre jobs ao sair
setopt NO_HUP                    # Não mata jobs ao fechar
setopt NOTIFY                    # Notifica mudanças imediatamente

# --- Prompt ------------------------------------------------------------------

setopt PROMPT_SUBST              # Permite expansão
setopt TRANSIENT_RPROMPT         # Remove right prompt após comando

# --- I/O behaviour -----------------------------------------------------------

setopt INTERACTIVE_COMMENTS      # Permite # em comandos
setopt RC_QUOTES                 # Permite '' dentro de ''
unsetopt CLOBBER                 # Protege contra sobrescrever com >
