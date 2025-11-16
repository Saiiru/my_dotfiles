# Workstation Directory Structure

## Root
```
workstation/
├── config/          # Application + service configs
├── docs/            # Documentation + reports
├── fonts/           # Font payloads and installers
├── install/         # Modular installer + helpers
├── scripts/         # Standalone scripts (taskwarrior, helpers)
├── themes/          # Shared colors/theme assets
├── wallpapers/      # Artwork packs
├── Justfile         # Task runner
├── README.md        # Primary documentation
├── TODO.md          # Open tasks
└── test-complete-setup.sh
```

## config/
```
config/
├── zsh/             # Shell bootstrap
├── tmux/            # Multiplexer config
├── kitty/           # Kitty terminal
├── ghostty/         # Ghostty terminal
├── mise/            # Runtime manager config
├── niri/            # Wayland compositor
├── quickshell/      # Shell widgets
├── systemd/         # User services
├── pipewire/        # Audio routing tweaks
├── wlogout/         # Logout menu
├── noctalia/        # Legacy scripts still referenced
└── Dark-Material-shell/  # Reference widgets/assets (kept for migration)
```

## install/
```
install/
├── install.sh         # Main entrypoint
├── symlinks-only.sh   # Only refresh symlinks
└── modules/
    ├── packages.sh    # Base package install
    ├── mise.sh        # Mise bootstrap
    ├── symlinks.sh    # Config links into ~/.config
    ├── tmux.sh        # TPM installer
    └── zsh.sh         # Shell defaults & znap
```

## scripts/
```
scripts/
└── taskwarrior-seeds.sh  # Example utility (more coming)
```

## Migration Checklist
1. Keep all configs inside `config/` with the same directory name used in `~/.config`.
2. Scripts that belong to a component live next to that component (e.g. quickshell scripts stay under `config/quickshell`).
3. Global helper scripts go into `scripts/` (or a future `bin/` if needed) and are added to PATH inside `config/zsh/core/00-environment.zsh`.
4. Installer modules should remain idempotent and avoid hardcoding `/gotham` (use `WORKSTATION_DIR`).
5. Validate everything with `just test` after restructuring.
