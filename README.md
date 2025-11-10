# Sairu's Hyprland Dotfiles

This repository contains the configuration files (dotfiles) for a highly customized Hyprland environment, built around the `quickshell` QML-based shell. This setup is designed for a modular, efficient, and visually appealing user experience.

## Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
  - [Hyprland Configuration](#hyprland-configuration)
  - [Quickshell Environment](#quickshell-environment)
  - [AMD GPU Compatibility](#amd-gpu-compatibility)
- [Key Features](#key-features)
- [Installation (Conceptual)](#installation-conceptual)
- [Troubleshooting](#troubleshooting)

## Overview

This dotfiles collection provides a complete configuration for a Hyprland desktop, leveraging `quickshell` for its UI elements (bar, widgets, menus). The configuration is modular, making it easier to manage and extend. Special attention has been given to ensuring compatibility with AMD GPUs.

## Architecture

The core of this setup revolves around a tightly integrated Hyprland and `quickshell` environment.

### Hyprland Configuration

The Hyprland configuration is located in `config_dotfiles/config/hypr/` and follows a modular structure:

-   **`hyprland.conf`**: The main configuration file, which sources smaller, specialized configuration files from the `modules/` directory.
-   **`modules/`**: Contains individual configuration files for different aspects of Hyprland, such as:
    -   `_variables.conf`: Defines global variables like colors and wallpaper paths.
    -   `animations.conf`: Configures window and workspace animations.
    -   `decoration.conf`: Manages window decorations, blur, and shadows.
    -   `env.conf`: Sets environment variables crucial for Wayland, QT, and other components.
    -   `general.conf`: Contains general Hyprland settings, gaps, borders, and layout.
    -   `input.conf`: Configures keyboard, mouse, and touchpad behavior.
    -   `keybinds.conf`: Defines all keyboard shortcuts for window management, application launching, and system actions.
    -   `misc.conf`: Miscellaneous Hyprland settings.
    -   `plugins.conf`: Configuration for Hyprland plugins (e.g., `hyprexpo`).
    -   `rules.conf`: Contains window and layer rules for specific applications and `quickshell` components.
-   **`scripts/`**: Houses various utility scripts used by Hyprland keybinds and `quickshell` services. These include scripts for:
    -   Screenshotting (`ScreenShot.sh`)
    -   Volume control (`Volume.sh`)
    -   Brightness control (`Brightness.sh`, `BrightnessKbd.sh`)
    -   Wallpaper management (`WallpaperSelect.sh`, `WallpaperRandom.sh`, `WallpaperEffects.sh`)
    -   System monitoring (`amd_gpu_temp.py`, `Weather.py`, `Weather.sh`, `WeatherWrap.sh`)
    -   Rofi menus (`RofiEmoji.sh`, `RofiSearch.sh`, `RofiCalc.sh`, `RofiThemeSelector.sh`)
    -   Session management (`LockScreen.sh`, `Wlogout.sh`)
    -   And many more.
-   **`UserConfigs/`**: This directory is intended for user-specific overrides and custom configurations, ensuring that core updates do not overwrite personal settings.

### Quickshell Environment

`quickshell` is a QML-based shell that provides the primary user interface elements, including:

-   **Bar**: Displays system information, workspaces, and application launchers.
-   **Widgets**: Desktop widgets for CPU/GPU temperature, system monitoring, clock, etc.
-   **Menus**: Application menus, power menus, and other interactive UI components.

Hyprland interacts with `quickshell` via IPC commands (e.g., `quickshell ipc call ...`) for actions like toggling the overview, showing cheatsheets, or controlling media.

### AMD GPU Compatibility

This setup is specifically configured for AMD GPUs. All NVIDIA-specific scripts and configurations have been removed or commented out to prevent errors and ensure optimal performance on AMD hardware. This includes:

-   Replacement of `nvidia_gpu_temp.py` with `amd_gpu_temp.py` for GPU temperature monitoring.
-   Removal of NVIDIA-specific process checks in `DgopService.qml`.
-   Commenting out `nvidia-smi` calls in `PerformanceService.qml`.

## Key Features

-   **Modular Configuration**: Easy to understand, modify, and maintain.
-   **Quickshell Integration**: Seamless UI experience with Hyprland.
-   **AMD GPU Support**: Optimized for AMD graphics hardware.
-   **Dynamic Theming**: Scripts for switching between dark/light themes and managing wallpapers.
-   **Comprehensive Keybinds**: Efficient keyboard-driven workflow.
-   **System Monitoring**: Integrated widgets and services for CPU, GPU, RAM, and network monitoring.

## Installation (Conceptual)

*(Note: Detailed installation steps are beyond the scope of this README, but typically involve symlinking configuration files and installing dependencies.)*

1.  **Clone the repository**:
    ```bash
    git clone https://github.com/your-username/dotfiles.git ~/dotfiles
    ```
2.  **Install Hyprland and Quickshell**: Follow their respective installation guides.
3.  **Install Dependencies**: Ensure all necessary packages for scripts (e.g., `grim`, `slurp`, `wl-clipboard`, `jq`, `python`, `python-requests`, `brightnessctl`, `pamixer`, `rofi`, `swaync`, `swww`, `wallust`, `cpupower`, `systemctl`) are installed.
4.  **Symlink Configuration Files**: Create symbolic links from `~/dotfiles/config_dotfiles/` to `~/.config/`.
5.  **Set up `quickshell`**: Ensure `quickshell` is correctly installed and configured to use the provided QML files.
6.  **Initial Setup**: Run any initial setup scripts if provided (e.g., for wallpaper, theme, etc.).

## Troubleshooting

-   **"Neither Quickshell nor AGS is available" notification**: This indicates that `quickshell` might not be running or is not accessible via `hyprctl dispatch global`. Ensure `qs` is running in the background (e.g., via `exec-once = qs &` in your Hyprland config).
-   **GPU temperature not showing**: Verify that `amd_gpu_temp.py` is executable and that its dependencies are met. Check `DgopService.qml` and the relevant desktop widgets for correct script paths.
-   **Keybinds not working**: Ensure `keybinds.conf` and `UserKeybinds.conf` are correctly sourced by `hyprland.conf`. Check for conflicts with other keybinds.
-   **Theming issues**: Ensure `wallust` is correctly configured and that `swww` is running for wallpaper management.

---

This README provides a high-level overview of the dotfiles structure and functionality. For detailed understanding and customization, refer to the individual configuration files and scripts.