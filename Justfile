#═══════════════════════════════════════════════════════════════════════
# GOTHAM SYSTEM — Master Control Panel
# Central command interface for all system operations
#═══════════════════════════════════════════════════════════════════════

# Default: Lista todos os comandos disponíveis
default:
    @just --list

#═══════════════════════════════════════════════════════════════════════
# INSTALLATION & SETUP
#═══════════════════════════════════════════════════════════════════════

# Instalação completa do sistema
install:
    @echo "╔══════════════════════════════════════════════════════════════╗"
    @echo "║     GOTHAM SYSTEM — Full Installation                        ║"
    @echo "╚══════════════════════════════════════════════════════════════╝"
    @bash {{justfile_directory()}}/scripts/install.sh

# Cria todos os symlinks
symlinks:
    @bash {{justfile_directory()}}/scripts/create-symlinks.sh

# Valida symlinks existentes
symlinks-check:
    @bash {{justfile_directory()}}/scripts/validate-symlinks.sh

#═══════════════════════════════════════════════════════════════════════
# VALIDATION & HEALTH
#═══════════════════════════════════════════════════════════════════════

# Validação completa do sistema
validate:
    @bash {{justfile_directory()}}/scripts/validate-system.sh

# Health check rápido
health:
    @echo "╔════════════════════════════════════════════════════════════╗"
    @echo "║  GOTHAM SYSTEM — Quick Health Check                       ║"
    @echo "╚════════════════════════════════════════════════════════════╝"
    @mise run check
    @echo ""
    @echo "Tmux sessions: $(tmux list-sessions 2>/dev/null | wc -l || echo 0)"
    @echo "Zsh plugins: $(ls -1 ~/.local/share/znap 2>/dev/null | wc -l || echo 0)"

# Diagnóstico completo
doctor:
    @mise run doctor
    @just symlinks-check

#═══════════════════════════════════════════════════════════════════════
# SYSTEM MAINTENANCE
#═══════════════════════════════════════════════════════════════════════

# Atualiza TODO o sistema (pacotes + mise + tmux plugins)
update:
    @echo "Updating system packages..."
    @paru -Syu --noconfirm || true
    @echo "Updating mise tools..."
    @mise upgrade || true
    @echo "Updating tmux plugins..."
    @~/.tmux/plugins/tpm/bin/update_plugins all || true
    @echo "✓ System updated"

# Limpa caches do sistema
clean:
    @echo "Cleaning system caches..."
    @rm -rf ~/.cache/zsh/* 2>/dev/null || true
    @rm -rf ~/.cache/mise/* 2>/dev/null || true
    @paru -Sc --noconfirm || true
    @echo "✓ Caches cleaned"

# Recarrega shell
reload:
    @tmux source-file ~/.config/tmux/tmux.conf 2>/dev/null || true
    @echo "✓ Tmux reloaded. Run 'exec zsh' to reload shell."

#═══════════════════════════════════════════════════════════════════════
# PROJECT MANAGEMENT
#═══════════════════════════════════════════════════════════════════════

# Cria novo projeto
new-project name type="generic":
    @zsh -c "source ~/gotham/shell/zsh/functions/projects.zsh && newproject {{name}} {{type}}"

# Abre projeto em sessão tmux
session project="":
    @zsh -c "source ~/gotham/shell/zsh/functions/projects.zsh && session {{project}}"

# Info do projeto atual
project-info:
    @zsh -c "source ~/gotham/shell/zsh/functions/projects.zsh && projectinfo"

#═══════════════════════════════════════════════════════════════════════
# PYTHON WORKFLOWS
#═══════════════════════════════════════════════════════════════════════

# Cria virtualenv Python
venv:
    @mise run py:venv

# Instala dependências Python
py-install:
    @mise run py:install

# Abre sessão Python
py-session:
    @just session python

#═══════════════════════════════════════════════════════════════════════
# NODE WORKFLOWS
#═══════════════════════════════════════════════════════════════════════

# Instala dependências Node
node-install:
    @mise run node:install

# Abre sessão Node
node-session:
    @just session node

#═══════════════════════════════════════════════════════════════════════
# GIT WORKFLOWS
#═══════════════════════════════════════════════════════════════════════

# Status do repositório com estatísticas
git-stats:
    @zsh -c "source ~/gotham/shell/zsh/functions/git.zsh && gstats"

# Limpa branches merged
git-clean:
    @zsh -c "source ~/gotham/shell/zsh/functions/git.zsh && gclean"

#═══════════════════════════════════════════════════════════════════════
# TMUX MANAGEMENT
#═══════════════════════════════════════════════════════════════════════

# Lista sessões tmux
tmux-list:
    @tmux list-sessions 2>/dev/null || echo "No active sessions"

# Mata todas as sessões tmux
tmux-kill:
    @tmux kill-server 2>/dev/null || echo "No sessions to kill"

# Instala plugins tmux
tmux-plugins:
    @~/.tmux/plugins/tpm/bin/install_plugins

#═══════════════════════════════════════════════════════════════════════
# LOGS & DEBUGGING
#═══════════════════════════════════════════════════════════════════════

# Mostra últimas 50 linhas do log
log:
    @tail -50 ~/.local/state/gotham/shell.log 2>/dev/null || echo "No logs yet"

# Segue log em tempo real
log-follow:
    @tail -f ~/.local/state/gotham/shell.log

# Limpa logs
log-clear:
    @echo "" > ~/.local/state/gotham/shell.log
    @echo "✓ Logs cleared"

#═══════════════════════════════════════════════════════════════════════
# BACKUP & RESTORE
#═══════════════════════════════════════════════════════════════════════

# Backup completo do sistema
backup:
    @bash {{justfile_directory()}}/scripts/backup.sh

# Lista backups disponíveis
backup-list:
    @ls -lht ~/gotham_backups/ 2>/dev/null || echo "No backups found"

#═══════════════════════════════════════════════════════════════════════
# DOCUMENTATION
#═══════════════════════════════════════════════════════════════════════

# Abre documentação completa
docs:
    @bat ~/gotham/README.md

# Mostra keybinds
keybinds:
    @bat ~/gotham/docs/KEYBINDS.md

# Mostra mapa de symlinks
symlinks-map:
    @bat ~/gotham/docs/SYMLINKS.md
