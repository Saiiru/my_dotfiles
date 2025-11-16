# Sairu's Workstation

[![Tmux](https://img.shields.io/badge/tmux-3.4-1BB91F?style=flat&logo=tmux&logoColor=white)](https://github.com/tmux/tmux)
[![Neovim](https://img.shields.io/badge/neovim-0.10+-57A143?style=flat&logo=neovim&logoColor=white)](https://neovim.io/)
[![Zsh](https://img.shields.io/badge/zsh-5.9-4E9A06?style=flat&logo=gnu-bash&logoColor=white)](https://www.zsh.org/)
[![Kitty](https://img.shields.io/badge/kitty-0.35+-3B5998?style=flat&logo=iterm2&logoColor=white)](https://sw.kovidgoyal.net/kitty/)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

> Cyberpunk-friendly terminal environment tuned for Wayland, tmux, Neovim and daily operator work.

## ✨ Highlights

- **🔧 Modern Shell** – Modular Zsh stack with deterministic PATH, logs, and Starship prompt.
- **📝 Neovim First** – Treesitter/LSP tuned config, lazy-loaded plugins, Snacks picker.
- **🖥️ Multiplexing** – Tmux + TPM + Sesh-ready keymaps with sane defaults.
- **🎨 Unified Theme** – Kitty, Ghostty, tmux, Starship share the same palette.
- **⚡ Toolchains** – Mise manages Python/Node/Rust/Go/Java versions per project.
- **🧰 Automation** – Install scripts + Justfile commands cover installs, updates, and tests.

## 📦 Requirements

| Component | Notes |
|-----------|-------|
| Git, Curl, Zsh | Required for installation script |
| Package manager | pacman or apt supported out of the box |
| Tmux ≥ 3.4 | Multiplexer |
| Neovim ≥ 0.10 | Editor |
| Kitty / Ghostty | Terminal configs provided |
| Starship, FZF, Eza, Bat, Ripgrep | Optional but recommended |

## 🚀 Install

```bash
# Clone (replace URL with your fork if needed)
git clone https://github.com/Saiiru/workstation.git ~/workstation
cd ~/workstation

# Deploy configs, dependencies, tmux TPM, etc.
./install/install.sh

# Reload shell for new PATH + aliases
exec zsh
```

What the installer does:

1. Validates Git/Curl/Zsh.
2. Installs base packages (pacman/apt aware).
3. Installs Mise toolchain manager if missing.
4. Creates all symlinks from `config/` into `~/.config` + `~/.zshrc`.
5. Sets up Zsh caches + Starship reference.
6. Installs/updates `~/.tmux/plugins/tpm` so tmux can be sourced cleanly.

Symlinks can be refreshed anytime with:

```bash
./install/symlinks-only.sh
```

## 🗂️ Layout

```
workstation/
├── config/          # All app/service configs (zsh, tmux, kitty, niri, quickshell...)
├── install/         # Modular installer + symlink helpers
│   ├── install.sh   # Main entrypoint
│   ├── symlinks-only.sh
│   └── modules/     # packages.sh, mise.sh, symlinks.sh, tmux.sh, zsh.sh
├── scripts/         # Utility scripts (e.g. taskwarrior seeds)
├── themes/          # Shared starship/kitty color assets
├── fonts/           # Custom font payloads (synced via scripts)
├── wallpapers/      # Assets for background rotation
├── docs/            # Architecture notes, migration logs, references
├── Justfile         # Common tasks (`just install`, `just test`, ...)
├── test-complete-setup.sh
└── TODO.md
```

## 🧰 Daily Commands

The [Justfile](./Justfile) exposes a few high-signal recipes:

| Command | Action |
|---------|--------|
| `just install` | Run the end-to-end installer |
| `just symlink` | Only recreate config symlinks |
| `just install-dev-tools` | `mise install` for language toolchains |
| `just update-dev-tools` | Upgrade existing Mise installs |
| `just clean` | Purge Zsh caches/zwc files |
| `just test` | Execute `test-complete-setup.sh` health suite |

## 🪟 Config Notes

### Zsh
- Rooted at `config/zsh/` with core modules (`core/`), plugins, aliases and custom functions.
- Environment bootstrap exports `WORKSTATION_DIR`, deterministic PATH, and log helpers that write to `${XDG_STATE_HOME}/workstation/shell.log`.
- Plugin manager: [zsh-snap](https://github.com/marlonrichert/zsh-snap) installed under `~/.local/share/znap` by the installer.

### Tmux
- Config lives in `config/tmux/tmux.conf` (symlinked to `~/.config/tmux`).
- TPM is installed into `~/.tmux/plugins/tpm` automatically. Launch tmux and hit `Ctrl-A I` to fetch/update plugins.
- Prefix = `Ctrl-A`, and Sesh integration is prewired.
- Session persistence via [tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect): `Ctrl-A Ctrl-S` saves, `Ctrl-A Ctrl-R` restores (state stored under `~/.local/state/tmux`).
- Quick reload: `Ctrl-A r` (or `Ctrl-A R`) re-sources the config without restarting tmux.

### Terminals
- Kitty + Ghostty share the same palette (`themes/`).
- Fonts live in `fonts/`; scripts in `~/.local/share/fonts` keep them in sync (outside the repo).

### Wayland Stack
- `config/niri`, `config/quickshell`, `config/systemd` capture compositor/services.
- `install/modules/symlinks.sh` links these into `~/.config` so user services (e.g. quickshell, pipewire tweaks) pick up the right files.

## 🧪 Validation

Run:

```bash
just test
```

This executes `test-complete-setup.sh`, which checks:
- Presence of key directories (`config`, `install`, `docs`, `themes`, `fonts`, `wallpapers`, `scripts`).
- Installer + module files.
- Symlinks in `~/.config` and `~/.zshrc`.
- Tool availability (zsh/tmux/nvim/mise) and tmux TPM installation.

## 📚 Docs & Roadmap

| File | Purpose |
|------|---------|
| [STRUCTURE.md](./STRUCTURE.md) | Repository map and migration notes |
| [PATH_MIGRATION.md](./PATH_MIGRATION.md) | Historical re-org log |
| [SCRIPTS_CLEANUP.md](./SCRIPTS_CLEANUP.md) | Script consolidation decisions |
| [TODO.md](./TODO.md) | Active setup tasks (zram, fonts, Wayland services, etc.) |

## 🤝 Contributing

Issues/PRs welcome. Fork, hack, and keep the `/install` modules in sync so the automation stays predictable.

## 📄 License

MIT — see [LICENSE](LICENSE).

## 👤 Author

**Sairu**
- GitHub: [@Sairu](https://github.com/Sairu)
- Repository: [workstation](https://github.com/Sairu/workstation)
