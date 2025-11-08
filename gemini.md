# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# GUIA DE CONFIGURAÇÃO - RED HOOD CYBERPUNK (GERADO POR GEMINI)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Este documento resume todas as modificações e configurações aplicadas ao seu sistema Arch Linux, com foco em um ambiente "Red Hood Cyberpunk" para ZSH, Hyprland e Mise.

## 🚀 Visão Geral

O objetivo foi criar um ambiente de terminal e desktop coeso, funcional e visualmente impactante, com automações para desenvolvimento e uma experiência de usuário aprimorada. Todas as dependências do `ags` foram removidas e substituídas por soluções nativas ou scripts simples.

---


## 📦 Instalação Inicial e Dependências

Antes de tudo, certifique-se de que as dependências básicas estão instaladas. O script `install-deps.sh` (que será criado no final) cuidará da maioria delas.

### 1. ZSH KORA NEON CYBERPUNK

Seu shell ZSH foi configurado para uma experiência cyberpunk imersiva, com um prompt Oh My Posh vibrante e diversas melhorias de produtividade.

**Arquivos Criados/Modificados em `~/dotfiles/zsh/`:**

*   `prompt/posh.json`: Tema Oh My Posh "Red Hood Cyberpunk" (o que você confirmou que funciona).
*   `prompt/posh-init.zsh`: Script de inicialização do Oh My Posh.
*   `.zshrc`: Configuração principal do ZSH, carregando módulos.
*   `env.zsh`: Variáveis de ambiente (editores, locale, Wayland, paths, FZF com cores KORA Neon).
*   `plugins.zsh`: Gerenciamento de plugins (autosuggestions, syntax highlighting).
*   `completion.zsh`: Configurações avançadas de autocompletar.
*   `fzf.zsh`: Integração FZF com widgets personalizados (`ff`, `fcd`, `fh`, `fbr`, `fkill`).
*   `aliases/aliases.zsh`: Aliases gerais (eza, bat, wl-clipboard, navegação, sistema).
*   `aliases/aliases_git.zsh`: Aliases para Git.
*   `aliases/aliases_docker.zsh`: Aliases para Docker e Docker Compose.
*   `aliases/aliases_kubernetes.zsh`: Aliases para Kubernetes.

**Para ativar:**

1.  Execute o script de deploy (veja a seção "Script de Deploy").
2.  Abra um novo terminal ou execute `exec zsh`.

### 2. HYPRLAND RED HOOD CYBERPUNK

Seu compositor Hyprland foi transformado com um tema "Red Hood Cyberpunk", incluindo bordas animadas, sombras neon e atalhos de teclado funcionais, sem dependências do `ags`.

**Arquivos Criados/Modificados em `~/dotfiles/config/hypr/hyprland/`:**

*   `hyprland.conf`: Arquivo principal que carrega todas as outras configurações modulares.
*   `variables.conf`: Definição da paleta de cores "Red Hood" e variáveis globais.
*   `looknfeel.conf`: Configurações visuais (gaps, bordas, sombras, blur) com o tema Red Hood.
*   `animations.conf`: Animações de janela e borda, incluindo o efeito de rotação do gradiente.
*   `keybinds.conf`: Atalhos de teclado atualizados, removendo dependências do `ags` e adicionando chamadas para `qsctl.sh` e scripts utilitários. Os atalhos de workspace e gravação de tela foram corrigidos.
*   `autostart.conf`: Scripts e serviços que iniciam com o Hyprland (Quickshell, cliphist, swww-daemon, mako, pipewire, hypridle, etc.).
*   `rules.conf`: Regras de janela para opacidade, flutuação e blur de aplicativos específicos.
*   `idle.conf`: Configuração do `hypridle` para bloqueio de tela e suspensão.
*   `hyprlock.conf`: Tema "Red Hood" para a tela de bloqueio `hyprlock`.
*   `environment.conf`: Variáveis de ambiente, incluindo `MOZ_ENABLE_WAYLAND=1` para Firefox e sugestões para AMD.
*   `input.conf`: Configurações de teclado (layout `br`) e touchpad.
*   `layers.conf`: Arquivo placeholder para configurações de camadas.
*   `general.conf`: **Corrigido** para resolver erros de sintaxe na seção `decoration` e `animations`, usando a sintaxe correta para `shadow` e `blur` com as cores Red Hood.

**Scripts Criados em `~/dotfiles/config/hypr/hyprland/scripts/`:**

*   `wallpaper.sh`: Gerenciador de wallpaper com transições aleatórias.
*   `cycle-border-color.sh`: Script para ciclar entre esquemas de cores de borda.
*   `neon-pulse.sh`: Efeito de pulso neon para as bordas.
*   `screen-record.sh`: Script unificado para gravação de tela (região, fullscreen, com/sem áudio).
*   `ollama-ask.sh`: Script para interagir com o Ollama (assistente AI).

**Para ativar:**

1.  Execute o script de deploy (veja a seção "Script de Deploy").
2.  Execute `hyprctl reload` no terminal ou reinicie o Hyprland.

### 3. MISE CONFIGURAÇÃO AVANÇADA

Seu `mise/config.toml` foi aprimorado para automação de desenvolvimento, gerenciamento de ferramentas e criação de projetos.

**Arquivo Modificado em `~/dotfiles/config/mise/`:**

*   `config.toml`: Configuração completa do `mise`.

**Principais Mudanças:**

*   **Desativada criação automática de `.venv`:** A linha `_.python.venv = { path = "`.venv"`, create = true }` foi alterada para `_.python.venv = { path = "`.venv"` }` para que você tenha controle total sobre a criação de ambientes virtuais Python.
*   **Suporte a Pacotes Globais:** O `mise` gerencia as versões das ferramentas, incluindo `npm`. Um teste para `http-server` global foi adicionado.
*   **Tarefas de Projeto (Project Automation):**
    *   **Node.js:** `node:install`, `node:build`, `node:test`, `node:start`, `node:init`.
    *   **Python:** `py:install` (com criação manual de venv), `py:test`, `py:fmt`, `py:init`.
    *   **Go:** `go:tidy`, `go:test`, `go:build`, `go:init`.
    *   **Rust:** `rust:build`, `rust:test`, `rust:init`.
    *   **Java (Maven):** `java:maven:package`, `java:maven:test` (JUnit), `java:maven:spring-init` (para criar projetos Spring Boot).
    *   **Java (Gradle):** `java:gradle:build`, `java:gradle:test` (JUnit), `java:gradle:spring-init`.
*   **Meta-Tarefas:** `install`, `build`, `test`, `fmt` foram atualizadas para abranger todos os tipos de projeto.

**Para ativar:**

1.  Execute o script de deploy (veja a seção "Script de Deploy").
2.  Execute `mise doctor` para verificar a instalação das ferramentas.
3.  Para testar o `http-server` global: `mise run npm:global-test`.

**Criação de Ambientes Virtuais Python (Manual):**

Para criar um `.venv` para um projeto Python, navegue até a pasta do projeto e execute:

```bash
python -m venv .venv
source .venv/bin/activate
mise run py:install # Para instalar as dependências do requirements.txt
```

### 4. QUICKSHELL (QS) / DMS IPC

Os scripts de controle IPC para o Quickshell foram atualizados e integrados aos keybinds do Hyprland.

**Scripts Criados/Modificados:**

*   `~/dotfiles/config/qs/ipc/qsctl.sh`: Controlador IPC para Quickshell (spotlight, notifications, dash, theme, wallpaper, etc.).
*   `~/dotfiles/config/qs/scripts/ollama-ask.sh`: Script para interagir com o Ollama (assistente AI), agora localizado em `~/dotfiles/config/hypr/hyprland/scripts/ollama-ask.sh` para centralizar scripts do Hyprland.

### 5. LIMPEZA DE `.venv`

Para remover todos os diretórios `.venv` que foram criados automaticamente ou que você não precisa mais:

```bash
find ~ -name ".venv" -type d -prune -exec rm -rf {} +
```

---


## 🛠️ Script de Deploy Unificado

Este script irá criar os symlinks necessários de `~/dotfiles/` para `~/.config/` e outros locais, garantindo que suas configurações estejam ativas e versionadas.

**Arquivo:** `~/dotfiles/deploy-dotfiles.sh`

```bash
#!/usr/bin/env bash
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# DEPLOY DOTFILES - RED HOOD CYBERPUNK
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

set -euo pipefail

TS=$(date +%Y%m%d-%H%M%S)
DOTFILES_ROOT="$HOME/dotfiles"

echo "🔗 Iniciando deploy dos dotfiles Red Hood Cyberpunk..."

backup_and_link() {
  local src="$1"
  local dest="$2"
  
  mkdir -p "$(dirname "$dest")"
  
  if [[ -e "$dest" && ! -L "$dest" ]]; then
    echo "  -> Fazendo backup de: $dest para ${dest}.bak.$TS"
    mv "$dest" "${dest}.bak.$TS"
  fi
  
  echo "  -> Criando symlink: $src -> $dest"
  ln -sfn "$src" "$dest"
}

# --- ZSH ---
echo "
Deploying ZSH..."
backup_and_link "$DOTFILES_ROOT/zsh/.zshrc" "$HOME/.zshrc"
mkdir -p "$HOME/.config/zsh"
# Zinit plugins (se não estiverem no sistema)
# zsh-autosuggestions
if [[ ! -d "$HOME/.zsh/zsh-autosuggestions" ]]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions "$HOME/.zsh/zsh-autosuggestions"
fi
# zsh-syntax-highlighting
if [[ ! -d "$HOME/.zsh/zsh-syntax-highlighting" ]]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting "$HOME/.zsh/zsh-syntax-highlighting"
fi

# --- Hyprland ---
echo "
Deploying Hyprland..."
mkdir -p "$HOME/.config/hypr/scripts"
for file in "$DOTFILES_ROOT/config/hypr/hyprland/"*;
  do
  filename=$(basename "$file")
  if [[ -f "$file" ]]; then
    backup_and_link "$file" "$HOME/.config/hypr/$filename"
  elif [[ -d "$file" ]]; then
    # Para diretórios como 'scripts', copiamos o conteúdo ou criamos symlink recursivo
    # Por simplicidade, vamos symlinkar o diretório inteiro de scripts
    backup_and_link "$file" "$HOME/.config/hypr/$filename"
  fi
done

# --- Mise ---
echo "
Deploying Mise..."
mkdir -p "$HOME/.config/mise"
backup_and_link "$DOTFILES_ROOT/config/mise/config.toml" "$HOME/.config/mise/config.toml"

# --- Quickshell (QS) ---
echo "
Deploying Quickshell..."
mkdir -p "$HOME/.config/qs/ipc"
mkdir -p "$HOME/.config/qs/scripts"
backup_and_link "$DOTFILES_ROOT/config/qs/ipc/qsctl.sh" "$HOME/.config/qs/ipc/qsctl.sh"
# O script ollama-ask.sh foi movido para hypr/scripts

# --- Kitty (se for o caso, adicionar aqui) ---
# echo "\nDeploying Kitty..."
# mkdir -p "$HOME/.config/kitty"
# backup_and_link "$DOTFILES_ROOT/config/kitty/kitty.conf" "$HOME/.config/kitty/kitty.conf"

# --- Ghostty (se for o caso, adicionar aqui) ---
# echo "\nDeploying Ghostty..."
# mkdir -p "$HOME/.config/ghostty"
# backup_and_link "$DOTFILES_ROOT/config/ghostty/config" "$HOME/.config/ghostty/config"

# --- Tmux (se for o caso, adicionar aqui) ---
# echo "\nDeploying Tmux..."
# backup_and_link "$DOTFILES_ROOT/config/tmux/.tmux.conf" "$HOME/.tmux.conf"

echo "
✅ Deploy de dotfiles concluído!"
```

---


## 🛠️ Script de Instalação de Dependências

Este script instala todas as dependências de pacotes via `pacman` e `paru` (ou `yay`).

**Arquivo:** `~/dotfiles/install-deps.sh`

```bash
#!/usr/bin/env bash
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# INSTALL DEPENDENCIES - RED HOOD CYBERPUNK
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

set -euo pipefail

echo "📦 Instalando dependências via pacman..."
sudo pacman -S --needed --noconfirm \
    zsh git curl wget unzip ripgrep fd fzf bat eza btop procs \
    wl-clipboard cliphist playerctl brightnessctl jq yq \
    swww hyprpicker kitty tmux grim slurp wf-recorder imagemagick \
    rofi-wayland libnotify mako cmatrix pipes-sh \
    python python-pip nodejs npm pnpm go rust cargo \
    jdk-openjdk maven gradle neovim

echo "
📦 Instalando dependências via AUR (oh-my-posh, quickshell, ghostty)..."

# Detecta AUR helper
if command -v paru >/dev/null; then
    AUR_HELPER="paru"
elif command -v yay >/dev/null; then
    AUR_HELPER="yay"
else
    echo "AVISO: Nenhum AUR helper (paru ou yay) encontrado. Instale oh-my-posh-bin, quickshell-git e ghostty-git manualmente."
    exit 1
fi

$AUR_HELPER -S --needed --noconfirm oh-my-posh-bin quickshell-git ghostty-git

echo "
📦 Instalando Mise..."
if ! command -v mise >/dev/null; then
    curl https://mise.run | sh
    # Adiciona ao .zshrc para ativação, mas o deploy-dotfiles.sh já cuida disso
fi

echo "
📦 Instalando Zinit..."
if [[ ! -d "${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git" ]]; then
    mkdir -p "${XDG_DATA_HOME:-$HOME/.local/share}/zinit"
    git clone https://github.com/zdharma-continuum/zinit.git \
        "${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
fi

echo "
📦 Instalando TPM (Tmux Plugin Manager)..."
if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

echo "
🤖 Instalando Ollama..."
if ! command -v ollama >/dev/null; then
    curl -fsSL https://ollama.com/install.sh | sh
fi

echo "
✅ Todas as dependências instaladas!"
```

---


## 🏁 Próximos Passos e Validação

Siga estes passos para finalizar a configuração:

1.  **Torne os scripts executáveis:**
    ```bash
    chmod +x ~/dotfiles/install-deps.sh
    chmod +x ~/dotfiles/deploy-dotfiles.sh
    chmod +x ~/dotfiles/config/hypr/hyprland/scripts/*.sh
    chmod +x ~/dotfiles/config/qs/ipc/qsctl.sh
    ```

2.  **Instale todas as dependências:**
    ```bash
    ~/dotfiles/install-deps.sh
    ```

3.  **Execute o deploy dos dotfiles:**
    ```bash
    ~/dotfiles/deploy-dotfiles.sh
    ```

4.  **Limpe os `.venv` antigos (opcional, mas recomendado):**
    ```bash
    find ~ -name ".venv" -type d -prune -exec rm -rf {} +
    ```

5.  **Mude seu shell padrão para ZSH:**
    ```bash
    chsh -s /bin/zsh
    ```

6.  **Reinicie seu sistema** ou, no mínimo, faça logout e login novamente para que todas as variáveis de ambiente e configurações do Hyprland sejam carregadas. Se não quiser reiniciar, execute:
    ```bash
    exec zsh # Para carregar o novo ZSH
    hyprctl reload # Para recarregar o Hyprland
    ```

7.  **Valide as configurações:**
    *   Abra um terminal: O prompt Oh My Posh deve estar visível.
    *   Verifique o Firefox: `firefox` deve abrir corretamente no Wayland.
    *   Teste os atalhos do Hyprland (ex: `SUPER + RETURN` para terminal, `SUPER + SPACE` para spotlight).
    *   Verifique o `mise`: `mise doctor` e `mise run npm:global-test`.
    *   Teste a criação de projetos: `mkdir my-node-app && cd my-node-app && mise run node:init`.

---


## ❓ Próximos Passos (Opcional)

Agora que a base está sólida, podemos continuar com:

*   **Kitty e Ghostty:** Customização completa com o tema "Red Hood".
*   **Tmux:** Configuração avançada.
*   **Codex CLI:** Se você tiver o nome exato ou um link, posso tentar integrar.
*   **Outras automações:** Qualquer outra ideia que você tenha!

Seu sistema está pronto para o combate, Sairu! 🦇⚡
