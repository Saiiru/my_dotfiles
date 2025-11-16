# Path Migration Report — Workstation

## ✅ Completed on 2025-11-16
- Repository renamed from `~/gotham` to `~/workstation`.
- All environment variables now reference `WORKSTATION_DIR`.
- Install scripts consolidated under `install/` with modular helpers.
- Symlink creation isolated to `install/modules/symlinks.sh` + `install/symlinks-only.sh`.
- TPM installation automated via `install/modules/tmux.sh`.
- Health checks updated to the new structure.

## 🗂️ Current Layout
```
~/workstation/
├── config/               # canonical source of truth
├── install/              # install/install.sh + modules/
├── themes/               # Starship + terminal colors
├── fonts/                # font payloads
├── wallpapers/
├── scripts/
├── docs/
└── misc docs (README, TODO, STRUCTURE, ...)
```

## 🔗 Symlink Targets
| Source | Target |
|--------|--------|
| `config/zsh/zshrc` | `~/.zshrc` |
| `config/zsh/` | `~/.config/zsh` |
| `config/kitty/` | `~/.config/kitty` |
| `config/ghostty/` | `~/.config/ghostty` |
| `config/tmux/` | `~/.config/tmux` |
| `config/mise/` | `~/.config/mise` |
| `config/niri/` | `~/.config/niri` |
| `config/wlogout/` | `~/.config/wlogout` |
| `config/quickshell/` | `~/.config/quickshell` |
| `config/systemd/` | `~/.config/systemd` |
| `config/pipewire/` | `~/.config/pipewire` |
| `themes/starship.toml` | `~/.config/starship.toml` |

## 🛠️ Scripts
- `install/install.sh` — orchestrates packages, mise, symlinks, zsh, tmux TPM.
- `install/symlinks-only.sh` — idempotent symlink refresher.
- `test-complete-setup.sh` — validates root layout, symlinks, tooling.

## ✅ Validation
Run `just test` after any path change to confirm:
1. Directories exist.
2. Symlinks are live.
3. Tools are on PATH.
4. TPM is installed under `~/.tmux/plugins/tpm`.
