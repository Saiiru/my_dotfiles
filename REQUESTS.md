# Red Hood Cyberpunk System Backlog

This document captures the current set of requirements and ideas discussed for customizing the Arch Linux environment (Hyprland + Quickshell + dotfiles) into a cohesive "Red Hood Cyberpunk" experience. Use it as the source of truth when resuming work.

## High-Level Goals
- Deliver a reproducible dotfiles setup for user **Sairu** with a neon, Gotham-inspired aesthetic.
- Unify Hyprland, Quickshell/DankMaterialShell (DMS), Zsh, Kitty/Ghostty, tmux, and mise configurations.
- Prioritize productivity, stability, and hardware-aware performance (AMD RX 580 GPU) while keeping the vibe.

## Hyprland & Desktop Experience
- Apply KORA neon palette across Hyprland with animated glitch borders, neon shadows, blur, and dimming.
- Maintain Omarchy/Hollywood workflow: reuse existing configs, add enhancements (looknfeel, autostart, bindings) without breaking compatibility.
- Integrate Quickshell widgets (spotlight, notifications, dashboard, audio, wallpaper, theme). Provide a cheatsheet for IPC bindings.
- Expand scripts: border glitches, neon pulse, wallpaper glitch transitions, Red Hood notifications, screen recorder, matrix screensaver.
- Customize Hyprlock and Hypridle with cyberpunk visuals, multi-stage idle actions, optional sound cues.
- Ensure omnichannel start-up: automatically run `omarchy-setup-dns`, launch DMS/Quickshell, swww, clipboard daemons, ollama, etc.

## Shell & Tooling
- Zsh stack: Zinit, modular files (env, plugins, completion, fzf, aliases), oh-my-posh prompt with Red Hood theme.
- Kitty and Ghostty terminal themes aligned with the palette (fonts, opacity, keybinds, gpu-friendly tweaks).
- tmux config with Red Hood styling, TPM integration, session utilities.
- mise v3 config hardened: toolchains (Node, Python, Go, Rust, Java, etc.), tasks with proper `outputs` arrays, project generators (Spring CLI, Node, Python, Go, Rust).
- Ollama helper script targeting Mistral 7B; clipboard integration.

## Documentation & UX
- Produce cheatsheets (markdown or widgets) summarizing keybinds for Hyprland, Quickshell, Zsh, Kitty, tmux, mise tasks.
- Keep AGENTS.md contributor guide up to date; consider cross-linking this backlog.

## Outstanding Questions
1. Should DMS remain optional or become the default shell layer? Confirm desired startup priority.
2. Does Kitty need additional Red Hood widgets (battery, GPU temperature) or should these live inside Quickshell?
3. Should Hyprland bindings also target niri or other compositors?

_Last updated: 2025-11-05 20:56:26_
