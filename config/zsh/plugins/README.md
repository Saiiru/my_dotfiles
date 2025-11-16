# ZSH Plugins

Plugin system usando znap para gerenciamento eficiente.

## Plugin Manager: znap

Localização: `~/.local/share/znap` (XDG compliant)

### Instalação Automática

O znap é instalado automaticamente no primeiro carregamento do shell se não estiver presente.

### Como Funciona

1. **00-init.zsh** - Carrega o znap primeiro
2. **tools.zsh** - Ferramentas (fzf, zoxide, mise, starship)
3. Outros plugins podem ser adicionados como arquivos .zsh

## Plugins Ativos

### tools.zsh
- **FZF** - Fuzzy finder
- **Zoxide** - Smart cd
- **Mise** - Toolchain manager  
- **Starship** - Prompt
- **Thefuck** - Command correction (lazy loaded)

## Adicionar Novo Plugin

Crie um arquivo na pasta `plugins/`:

```zsh
# plugins/meu-plugin.zsh
if command -v ferramenta >/dev/null 2>&1; then
    znap eval ferramenta 'ferramenta init zsh'
fi
```

O arquivo será carregado automaticamente.

## Localização dos Plugins

Antes (incorreto):
- ❌ ~/dotfiles/

Depois (correto):
- ✅ ~/.local/share/znap/ (plugin manager)
- ✅ ~/.cache/znap/ (cache)
- ✅ ~/workstation/config/zsh/plugins/ (configurações)

## Znap Commands

```zsh
znap eval ferramenta 'command'  # Avalia e cacheia output
znap source user/repo           # Instala e sourcea plugin do GitHub
```

Mais info: https://github.com/marlonrichert/zsh-snap
