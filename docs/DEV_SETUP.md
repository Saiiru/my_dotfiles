# Development Environment - Gotham System

Professional multi-platform development stack.

## 🎯 Stack Overview

- **Embedded**: Arduino, ESP32, PlatformIO
- **Mobile**: Android SDK, ADB
- **Languages**: Python, Node.js, Go, Rust, Java
- **Runtime Manager**: Mise
- **Containers**: Docker

## 🚀 Quick Setup

```bash
# 1. Run auto-fix
~/gotham/bin/system/dev-fix.sh

# 2. Logout/login for groups

# 3. Install runtimes
mise install

# 4. Verify
~/gotham/bin/system/dev-audit.sh
```

## 📦 Components

### Mise (Runtime Manager)

Config: `~/gotham/config/mise/config.toml`

```bash
# Activate in shell
eval "$(mise activate bash)"

# Install runtimes
mise use --global python@3.12
mise use --global node@20

# Per-project versions
mise use python@3.11  # in project dir
```

### Arduino/ESP32

```bash
# Install
sudo pacman -S arduino-cli platformio

# Setup cores
arduino-cli core install arduino:avr
arduino-cli core install esp32:esp32

# Test
arduino-cli board list
```

### Android

```bash
# Install tools
sudo pacman -S android-tools

# Setup SDK (optional)
export ANDROID_HOME="$HOME/Android/Sdk"
export PATH="$PATH:$ANDROID_HOME/platform-tools"

# Test
adb devices
```

## 🔧 Troubleshooting

### Serial Permission Denied

```bash
sudo usermod -aG uucp,lock $USER
# Logout/login
```

### ADB Device Not Found

```bash
# Check USB debugging on phone
adb kill-server && adb start-server
```

### Mise Python Not Found

```bash
# Check activation
eval "$(mise activate bash)"
mise install python@3.12
```

## 📊 Validation

```bash
~/gotham/bin/system/dev-audit.sh
```

Expected: All checks ✓

## 📚 Resources

- Mise: https://mise.jdx.dev/
- Arduino CLI: https://arduino.github.io/arduino-cli/
- Android ADB: https://developer.android.com/tools/adb
