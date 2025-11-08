# Taskwarrior :: Watch_Dogs profile

Symlink `~/dotfiles/config/task/taskrc` to `~/.taskrc` (or set `TASKRC`) so
tmux scripts and the Pomodoro engine pull consistent reports. Hooks live in
`config/task/hooks` and the default `on-modify.timewarrior` script keeps
Timewarrior in sync automatically.

```
ln -sf ~/dotfiles/config/task/taskrc ~/.taskrc
mkdir -p ~/.task/hooks
ln -sf ~/dotfiles/config/task/hooks/on-modify.timewarrior ~/.task/hooks/
```

Requirements: `task`, `timew`, `jq`. The hook safely no-ops if Timewarrior
isn't installed, so you can enable it everywhere. Use `bin/watchdogs-tasks`
para abrir o TUI (via tmux: `prefix + t`).
