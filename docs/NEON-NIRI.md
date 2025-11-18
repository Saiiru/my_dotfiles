# NEON-NIRI v2 Notes

## Overview
The NEON-NIRI stack groups workstation tuning into three contexts:

| Context | Focus | CPU/GPU | Extras |
|---------|-------|---------|--------|
| DEFAULT | Daily driver | `schedutil`, stock GPU | GameMode off, base Niri config |
| DEV     | Heavy multitasking | `schedutil`, balanced GPU | Dev overlay appended to base config |
| GAME    | High performance | `performance`, AMD/NVIDIA boost | GameMode on, MangoHud/GameHUD helpers, Game overlay |

State + logs live under `~/.local/state/neon-niri/` so every component (systemd, CLI, Quickshell) talks to the same files.

## Context Engine
- `scripts/context-switch` is the single entrypoint. It handles locking, governor changes, GameMode toggles, config regeneration, `niri msg reload-config`, notifications, and writes `system-context` + `context-switch.log`.
- Systemd units:
  - `context-default.service` calls `context-switch default` at login.
  - `gamemoded.service` keeps Feral GameMode available for manual triggers or the GAME context.
- Paths referenced by the engine:
  - Configs: `config/niri/base|dev-mode|game-mode.kdl`
  - State: `~/.local/state/neon-niri/system-context`
  - Logs: `~/.local/state/neon-niri/context-switch.log`

## Quickshell Integration
- `Services/ContextService.qml` watches the state file via `FileView`, builds metadata for each context (name/icon/colors), exposes helpers to cycle/target contexts, and shells out to `context-switch` when requested.
- `Modules/TopBar/ContextIndicator.qml` adds a widget that shows the active mode, description, quick status spinner, tooltip with the state path, mouse wheel cycling, and a right-click menu for direct selection.
- Defaults were updated so the Context widget lives between the workspace switcher and focused window modules. Settings → Top Bar now lists the widget for reordering/disablement.

## Automation (Justfile)
- New recipes: `context-status`, `context-default`, `context-dev`, `context-game`, `context-log` plus rollups `neon-setup` (install → DEFAULT) and `neon-update` (symlinks + toolchains → status).
- `install/modules/symlinks.sh` now links `config/gamemode`, `config/mangohud`, `config/neon-niri`, and the executable scripts (`context-switch`, `game-launcher`, `neon-perfmon`, `wine-prefix-manager`) into `~/.local/bin`.

## Gaming Stack
- **GameMode**: `config/gamemode/gamemode.ini` + `scripts/gamemode-start.sh` / `gamemode-end.sh` stop noisy services, tweak NVMe schedulers, flush caches, and log each activation.
- **MangoHud**: `config/mangohud/MangoHud.conf` defines the default overlay with neon colors and telemetry. Presets (`minimal`, `competitive`, `full`) live under `config/mangohud/presets/`.
- **Launcher**: `scripts/game-launcher` reads `config/neon-niri/games.db`, presents a rofi/fzf/select UI, ensures GAME context, and launches Steam/Lutris/native/Wine titles (Sekiro entry included). It records the last launched game and tails events to `game-launcher.log`.
- **Monitoring/Prefixes**: `scripts/neon-perfmon` prints a live CPU/GPU/RAM dashboard; `scripts/wine-prefix-manager` lists/creates/deletes prefixes and proxies winetricks calls.

## Validation Checklist
1. `just context-status` shows `DEFAULT` after login (systemd unit works).
2. Switch contexts via widget/CLI and tail `~/.local/state/neon-niri/context-switch.log` for matching entries.
3. Launch `game-launcher` (choose Sekiro) — the GAME context should trigger and MangoHud overlay should start.
4. Run `neon-perfmon` to verify sensors + context readouts.
5. Use Quickshell Top Bar → context menu to hop between DEV/GAME; ensure the state file updates and `context-switch` logs match each transition.
