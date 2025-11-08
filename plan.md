 Hyprland and QuickShell configs in config/ are the live source of truth; legacy copies live only in
    hypr.old/ and qs.old/.
  - Static red borders, toned‑down terminal opacity, and QuickShell palette calls via plain qs keep the
    Wayland stack cohesive.
  - Mise no longer nags for env creation and includes session:java plus bin/java-dev for tmux-based Java
    workflows.

  Key Opportunities

  - Retire legacy snapshots: config/hypr.old/ and config/qs.old/ duplicate the active configs. Removing or
    archiving them outside the repo will avoid confusion (they’re still vulnerable to drift).
  - QuickShell settings cleanup: config/DankMaterialShell/settings.json still has NVIDIA GPU features
    enabled by default ("desktopGpuSelection": "auto", GPU widgets toggled on). Set showGpuTemp/
    desktopGpuSelection to AMD-friendly defaults or expose a toggle script so NVML isn’t assumed.
  - Desktop temperature widget: In config/quickshell/Modules/Desktop/DesktopSystemMonitorWidget.qml, add
    a guard so currentGpuTemperature respects nvmlSupported before pulling from DgopService.availableGpus;
    currently it only hides the text, but the service still tries to populate an empty list.
  - Hypr script polishing: Scripts like config/hypr/scripts/glitch-border.sh/neon-pulse.sh are unused after
    switching to static borders; consider removing or documenting them in README to prevent accidental
    activation.
  - Terminal opacity consistency: You added Hypr rules for kitty/ghostty and tuned their configs—great.
    Check if any other terminals (e.g., fuzzel, walker) need similar adjustments for transparency blur
    consistency.
  - Mise project scaffolds: The tmux session builder assumes Maven/Gradle wrappers. For robustness, wrap
    the long-running loops in session:java with checks and perhaps use separate panes rather than infinite
    loops (currently the test pane reruns forever).
  - QuickShell bar content: showWeather remains true; if you don’t use weather (or don’t have credentials),
    disable it to avoid empty widgets. Also consider trimming unused widgets (clipboard, system tray) via
    settings.json to keep the bar minimal as requested.
  - Config docs: With configs centralized in config/, you may want a short README.md there listing required
    packages/fonts (Material Symbols, JetBrainsMono, etc.) and the new helper commands (java-dev, mise
    run session:java).
  - Systemd leftovers: config/systemd/user/omarchy-battery-monitor.* might be redundant since battery is
    hidden; either remove the units or document how to use them.

  Suggested Next Actions

  1. Delete or move config/hypr.old and config/qs.old outside the repo.
  2. Update config/DankMaterialShell/settings.json → disable GPU widgets and weather if unused; set
     desktopGpuSelection to a static AMD label or "none".
  3. In DesktopSystemMonitorWidget.qml, gate NVML polling by clearing DgopService.availableGpus when
     nvmlSupported is false, so no bogus readings appear.
  4. Remove unused Hypr scripts (glitch-border.sh, neon-pulse.sh) or move them into an archive/ folder with
     a note.
  5. Tweak session:java to run tests on demand (e.g., bind prefix t to trigger) instead of an endless loop.
  6. Add a config/README.md summarizing setup (fonts, QuickShell restart, tmux plugins) and noting the new
     helper commands.
  7. If weather isn’t configured, set "showWeather": false and prune the weather widgets from
     settings.json.

  Apply these and your environment stays lean, predictable, and AMD-friendly. I’m ready to help implement
  any of them—just say the word.


› o que tem no DankMaterialSHell, ja esta no meu quickshell, é dentro dessa pasta que eu quero as coisas.
  mantenha os scripts mas faça eles serem ativados por um do quickshell ou coisa assim. eu quero que ele remova tudo, coloque isso no meu neovim
