# Repository Guidelines

## Project Structure & Module Organization
- `config/` collects user-facing application configs. `config/hypr/hyprland/` holds base Hyprland profiles that are sourced by `config/hypr/hyprland.conf`, while `config/hypr/custom/` is for host-specific overrides. Keep monitors in `config/hypr/monitors.conf` so they load first.
- `config/mise/config.toml` tracks runtime tool versions; update it whenever you add a new toolchain referenced by these dotfiles.
- `zsh/` contains modular shell configuration: `prompt/`, `aliases/`, `plugins.zsh`, and `env.zsh` compose `.zshrc`.
- Root scripts such as `deploy-zsh.sh` (symlinks dotfiles) and `install-zsh-deps.sh` (installs arch packages) orchestrate deployment. Reference docs like `mise_cheatsheet.md` for context.

## Build, Test, and Development Commands
- `./deploy-zsh.sh` — backs up any existing `.zshrc` and symlinks the curated configuration; run after editing `zsh/`.
- `./install-zsh-deps.sh` — installs required packages via `pacman` and an AUR helper; ensure sudo access before running.
- `hyprctl reload` — reload Hyprland after adjusting files in `config/hypr/`.
- `mise doctor` — verify that runtimes declared in `config/mise/config.toml` are installed; follow up with `mise install` if tooling is missing.

## Coding Style & Naming Conventions
- Keep shell scripts POSIX-friendly but target Bash: include `#!/usr/bin/env bash`, `set -euo pipefail`, four-space indentation, and double-quote expansions.
- Use uppercase snake case for exported variables (e.g., `DOTFILES_DIR`) and kebab-case for filenames (`install-zsh-deps.sh`).
- Hyprland configs rely on hierarchical sourcing; place reusable defaults in `hyprland/` and machine-specific adjustments in `custom/` to avoid merge churn.
- Zsh modules should remain single-purpose and sourced from `plugins.zsh`; prefer lowercase function names (e.g., `fzf_preview()`).

## Testing Guidelines
- Validate shell changes with `zsh -n zsh/.zshrc` and `shellcheck deploy-zsh.sh install-zsh-deps.sh` before opening a PR.
- After editing Hyprland files, run `hyprctl reload && journalctl --user-unit=hyprland -b | tail` to confirm successful parsing.
- For new mise entries, run `mise run` or the relevant task once to ensure the shims resolve as expected.

## Commit & Pull Request Guidelines
- The repository has no published history; follow Conventional Commits (e.g., `feat: add hyprlock shader presets`) and keep subject lines under 72 characters.
- Squash or rebase to maintain a linear history, link any tracking issues, and describe host environments affected (e.g., "Framework 13 / Arch").
- Include before/after screenshots or short terminal captures when tweaking themes, prompts, or Hyprland visuals, and note any manual follow-up steps required.

## Security & Configuration Tips
- Do not commit secrets, tokens, or machine-unique paths; use `custom/` overlays or local `.env` files kept outside the repo.
- When adding packages to install scripts, prefer widely available repositories and document manual steps in `gemini.md` or a new doc to keep onboarding smooth.
