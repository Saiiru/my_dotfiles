# Red Hood Implementation Plan

This roadmap breaks the "Red Hood Cyberpunk" backlog into actionable work packages. Follow the phases in order so we can validate each subsystem before stacking more changes.

## Phase 1 – Configuration Architecture
- [ ] Create `config/redhood/` namespace to contain all new themes, scripts, and schemas so we avoid colliding with upstream Omarchy/DMS updates.
- [ ] Add a `config/redhood/README.md` explaining layout and crosslinks to Omarchy defaults.
- [ ] Update `deploy` logic (later) to symlink new assets into `$XDG_CONFIG_HOME` while keeping existing files intact.

## Phase 2 – Hyprland Visual Stack
- [x] Derive new Hyprland visuals in `custom/general.conf`, overriding base theme with neon borders, shadows, and tuned animations.
- [x] Implement holographic border presets and glitch/pulse toggles:
  * new scripts under `config/hypr/scripts/`.
  * integrated bindings via `custom/keybinds.conf`.
- [x] Replace/extend `hyprlock.conf` and `hypridle.conf` with Red Hood versions (multi-stage idle actions, neon lock UI).
- [x] Ensure `custom/execs.conf` triggers automatic DNS setup and primes visual scripts at session start.
- [ ] Add validators (bash scripts) to check `hyprctl reload`, wallpaper assets, shader compatibility.

## Phase 3 – Quickshell / DankMaterialShell Integration
- [ ] Build Red Hood theme JSON for DMS (leveraging KORA palette, subtle gradients, azure neon highlights).
- [ ] Extend existing widgets:
  * GPU widget → read RX 580 temps/power via `/sys/class/drm` or `sensors` and fall back gracefully.
  * Add cheatsheet modal summarizing key Hyprland + QS + terminal shortcuts (QML overlay triggered by `Super+Shift+?`).
  * Update control center accents to match neon palette; ensure dark/light toggles behave.
- [ ] Provide CLI helpers in `~/.config/qs/ipc/` (`qsctl.sh`, `dms-compat.sh`) with new commands for borders, pulse, wallpaper, mise tasks.
- [ ] Document IPC endpoints in `config/redhood/quickshell/IPC.md` and update `REQUESTS.md` cross-reference.

## Phase 4 – Terminal & Prompt Stack
- [ ] Author Red Hood themed configs:
  * `config/redhood/kitty/kitty.conf` (JetBrainsMono NF, neon opacity, glitch tab bar, GPU hints).
  * `config/redhood/ghostty/config` (matching palette, performance flags for Wayland, IosevkaTerm variant).
  * `config/redhood/tmux/tmux.conf` (C-b prefix, TPM, neon statusline, widgets for mise tasks / git).
- [ ] Generate compatible themes for oh-my-posh (`zsh/prompt/red-hood.json`) and fallback ANSI prompt.
- [ ] Add optional shell widgets (ASCII header, system summary) gated by env variables for performance.

## Phase 5 – Shell Automation & mise Enhancements
- [ ] Harden `config/mise/config.toml`: ensure outputs arrays cover every task, add project scaffolding commands (Spring tests with JUnit, Node + Vitest, Rust workspace, Docker combos).
- [ ] Create `bin/mise-new.sh` wrapper that lets user choose stacks interactively (dialog + templated README).
- [ ] Update `mise_cheatsheet.md` once tasks finalized.
- [ ] Expand Zsh modules (`plugins.zsh`, `aliases/*.zsh`) with new functions for Ollama, qs IPC, wallpaper cycle, hyprctl diagnostics.

## Phase 6 – Automation & Deploy Scripts
- [ ] Build `bin/deploy-redhood.sh` which:
  * backs up conflicting files (`*.bak.<timestamp>`),
  * applies symlinks for Hyprland, QuickShell, terminals, zsh, mise,
  * initializes caches (qs IPC, zsh compdump),
  * offers dry-run mode.
- [ ] Provide `bin/validate-env.sh` to run smoke tests (hyprctl, qs ipc, mise doctor, poetry/pnpm presence).
- [ ] Integrate these scripts into the existing `deploy-zsh.sh`/`install-zsh-deps.sh` when ready.

## Phase 7 – Documentation & Cheatsheets
- [ ] Produce `docs/cheatsheets/` containing:
  * `hyprland.md` – all Red Hood keybinds + script toggles.
  * `quickshell.md` – spotlight/dash/notifications/cheatsheet usage.
  * `shell.md` – zsh, kitty, tmux, mise commands.
- [ ] Update `AGENTS.md` and `REQUESTS.md` to reference new docs.
- [ ] Optionally generate Markdown from the cheatsheet modal for offline access.

## Phase 8 – Validation & QA
- [ ] Run Hyprland reload tests on staging session; verify animations on RX 580 (watch FPS via `hyprctl replay` + `MESA_VK_WSI_PRESENT_MODE=mailbox`).
- [ ] Confirm Quickshell widgets update within <100ms, no blocking calls on main thread (use `qs --profile` if available).
- [ ] Stress test mise tasks (node/go/python/rust) with sample projects.
- [ ] Document known limitations and fallback behavior in `docs/KNOWN_ISSUES.md`.

---

> **Next Step:** Start Phase 2 by creating the Red Hood Hyprland theme directory and porting existing snippets into modular files (keeping Omarchy defaults intact).
