# tmux :: Watch_Dogs // Catppuccin Ops

## Prefix & Theme
- Prefix `Ctrl+a`; HUD usa Catppuccin Mocha + acentos Watch_Dogs (verde neon).
- Status esquerdo: `◢ #S` + `gitmux`. Direita: `pomodoro.sh status ▕ taskw-summary ▕ relógio`.
- Janelas numeradas a partir de 1; posição do status no topo; mouse e truecolor ativos.

## Navegação & Panes
- `prefix + c` nova janela (cwd atual).
- `prefix + |` split horizontal · `prefix + -` split vertical · `prefix + s/v` atalhos extras.
- `prefix + h/j/k/l` move panes · `prefix + ,/.` resize fino · `prefix + _/+` resize grosso.
- `prefix + H/L` muda janelas · `prefix + C-a` volta à última janela · `prefix + z` zoom.
- Copy-mode Vi: `Esc`, `v` seleciona, `y/Enter` copia com `wl-copy`, `n/N` busca, `Ctrl+h/j/k/l` move.

## Session Ops & Plugins
- `prefix + K` Choose-tree popup 88×85 (visão geral da sessão).
- `prefix + O` (tmux-sessionx) catálogo interativo (`@sessionx-bind`).
- `prefix + S` abre `tmux-sessionx` em popup dedicado.
- `prefix + Space` → tmux-thumbs (plugin) para copiar itens na tela.
- `prefix + p` → tmux-floax scratch pad (bind padrão `@floax-bind`).
- URLs: selecione e abra com tmux-fzf-url (`prefix + U` padrão plugin) – com opções personalizadas `-p 60%,30%`.

## Notas, Tasks e Pomodoro
- `prefix + G` → Grimório (`~/Documents/Grimorio.md`).
- `prefix + T` → Taskwarrior board (TOP, watch list, context, Timewarrior summary).
- `prefix + t` ou `prefix + Ctrl+t` → nova TUI (`bin/watchdogs-tasks`) com fzf (enter=info, ctrl-s start, ctrl-t stop, ctrl-d done, ctrl-b inicia Pomodoro, ctrl-n cria tarefa).
- `prefix + P` → popup Pomodoro nativo (start/abort/monitor).
- `Ctrl+Shift+P` → inicia/pausa ciclo padrão 25m; `Ctrl+Shift+B` pausa 5m; `Ctrl+Shift+S` aborta.

## Taskwarrior + Timewarrior Workflow
- Config central em `config/task/taskrc` (symlink para `~/.taskrc`). Hooks em `config/task/hooks/on-modify.timewarrior` (symlink para `~/.task/hooks/`).
- Relatório `watchdogs` (ID, tempo desde start, urgência, projeto, descrição) alimenta TUI e board; flag `+watch` mantém segunda coluna.
- Pomodoro e Task TUI chamam `task <id> start/stop/done` e o hook sincroniza Timewarrior.
- Script `bin/watchdogs-tasks` também dispara `pomodoro.sh start 25 <id>` (mantendo badges do status).

## Tmux Launchers & Kitty
- `bin/watchdogs-tmux` garante servidor `tmux -L watchdogs`, sessão `matrix` com janelas Dev/Ops pré-criadas.
- `kitty_mod+Shift+t` (Ctrl+Shift+T) abre uma nova janela Kitty já anexada ao stack Watch_Dogs.

## Pomodoro Engine
- Arquivo `config/tmux/scripts/pomodoro.sh` controla foco/break, estado fica em `${XDG_STATE_HOME:-~/.local/state}/watchdogs-pomo`.
- Sem `jq` → badge mostra `⏱ --:--` (instale com `sudo pacman -S jq` e reabra tmux).
- Notificações via `notify-send`; se executar com `pomodoro.sh start 25 12`, inicia ciclo atrelado à tarefa 12 e liga Timewarrior automaticamente.

## Mise / Dev Stack
- `config/mise/config.toml` instala Python 3.12, Python 2.7, PyPy3, Node LTS, Go 1.22, Java 21 (Temurin), Rust stable, dotnet 8, toolchain LLVM/GCC/Clang/CMake/Ninja/Meson.
- `mise run py:global:init` provisiona ambientes globais (`~/.ve/jupyter3`, `~/.ve/ipython2`, tools2/tools3) com kernels do Jupyter.
- Tarefas adicionais para Node, Go, Java (Maven/Gradle), Rust, Docker, e agora C/C++ (`mise run c:configure`, `c:build`, `c:test`).

## Validação Rápida
1. `mise doctor` e `mise install` para aplicar toolchains (Python2 exige plugin habilitado).
2. `ln -sf ~/dotfiles/config/task/taskrc ~/.taskrc` e `ln -sf ~/dotfiles/config/task/hooks/on-modify.timewarrior ~/.task/hooks/` (já criado, confirme com `task diag`).
3. `watchdogs-tmux` (ou `kitty Ctrl+Shift+T`) → cria/entra no servidor `-L watchdogs`.
4. Dentro do tmux: testar `prefix + K/O/S/G/T/t/P` e `Ctrl+Shift+P/B/S` (popups devem permanecer abertos até fechar).
5. No TUI (`prefix + t`), use `ctrl-n` para criar tarefa, `ctrl-b` para iniciar Pomodoro; badge no status deve mudar para `FOC mm:ss`.
6. Board (`prefix + T`) precisa listar `watchdogs`, `+watch`, contexto e output do `timew summary` (instale Timewarrior se vazio).
