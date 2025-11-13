# Gotham Development Environment

Professional multi-language development setup with automated tooling.

## 🎯 Overview

Complete development environment for:
- **Multi-language**: Python, Node.js, Go, Rust, Java
- **Embedded**: Arduino, ESP32, PlatformIO
- **Mobile**: Android SDK, ADB
- **DevOps**: Docker, Kubernetes, Terraform
- **Runtime Management**: Mise (unified version management)

## 🔧 Quick Start

### 1. Audit Your Environment

```bash
dev-audit.sh
```

This checks:
- ✅ All programming languages installed
- ✅ Development tools (poetry, pnpm, cargo, etc)
- ✅ System permissions (serial, docker, adb)
- ✅ Hardware access (udev rules)

### 2. Auto-Fix Issues

```bash
sudo dev-fix.sh
```

Automatically:
- Installs missing packages
- Configures user groups
- Creates udev rules
- Sets up mise
- Initializes toolchains

### 3. Install Development Tools

```bash
mise install
```

Installs all configured tools from `config/mise/config.toml`.

## 📦 Installed Tools

### Core Languages

| Language | Version | Manager |
|----------|---------|---------|
| Python   | 3.12    | mise    |
| Node.js  | 20      | mise    |
| Go       | 1.21    | mise    |
| Rust     | stable  | rustup  |
| Java     | 21      | mise    |

### Python Ecosystem

```toml
"pipx:poetry" = "latest"    # Dependency management
"pipx:ruff" = "latest"      # Fast linter
"pipx:black" = "latest"     # Code formatter
"pipx:mypy" = "latest"      # Type checker
```

### Node.js Ecosystem

```toml
"npm:pnpm" = "latest"       # Fast package manager
"npm:yarn" = "latest"       # Alternative package manager
"npm:tree-sitter-cli" = "latest"  # Parser generator
```

### Rust Ecosystem

Use `rustup` for Rust toolchains (better LSP integration):

```bash
rustup toolchain install stable
rustup component add rust-analyzer
```

### Go Ecosystem

```toml
"go:github.com/golangci/golangci-lint/cmd/golangci-lint" = "latest"
"go:golang.org/x/tools/gopls" = "latest"  # LSP
"go:github.com/go-delve/delve/cmd/dlv" = "latest"  # Debugger
```

### DevOps Tools

```toml
kubectl = "latest"          # Kubernetes CLI
helm = "latest"            # Package manager for K8s
terraform = "latest"       # Infrastructure as Code
awscli = "latest"         # AWS CLI
postgres = "latest"       # Database
```

## 🔌 Hardware Development

### Arduino/ESP32

**Installed via pacman:**
- `arduino-cli` - Command-line interface
- `platformio` - Professional IDE

**Permissions:**

```bash
# User is in uucp/lock groups (auto-configured by dev-fix.sh)
groups | grep uucp

# Serial devices accessible
ls -la /dev/ttyUSB* /dev/ttyACM*
```

**Usage:**

```bash
# List connected boards
arduino-cli board list

# Compile and upload
arduino-cli compile --fqbn arduino:avr:uno sketch/
arduino-cli upload -p /dev/ttyUSB0 --fqbn arduino:avr:uno sketch/

# PlatformIO
pio run
pio run --target upload
```

### Android Development

**Requirements:**
- Android SDK (install via Android Studio or command-line tools)
- `adb` and `fastboot` (installed by dev-fix.sh)

**Environment:**

```bash
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
```

**Usage:**

```bash
# List connected devices
adb devices

# Install APK
adb install app.apk

# Logcat
adb logcat

# Fastboot (bootloader mode)
fastboot devices
fastboot flash recovery recovery.img
```

## 🎨 Neovim Integration

### Clipboard (System Integration)

```lua
-- Configured in lua/options.lua
vim.opt.clipboard = "unnamedplus"
```

**Usage:**
- `v` → Select text
- `y` → Yank (copy to system clipboard)
- `Y` → Yank full line
- `p` → Paste from system clipboard
- Works with `xclip` or `wl-clipboard`

### LSP Servers (Auto-installed by Mason)

Configured in `lua/plugins/lspconfig.lua`:
- `pyright` - Python
- `ts_ls` - TypeScript/JavaScript
- `gopls` - Go
- `rust_analyzer` - Rust
- `jdtls` - Java

### Tree-sitter (Syntax Highlighting)

```bash
# Install tree-sitter CLI
mise install npm:tree-sitter-cli

# Or via npm
npm install -g tree-sitter-cli
```

## 📊 Mise Configuration

### Global Config

Location: `~/.config/mise/config.toml` (symlinked to `~/gotham/config/mise/config.toml`)

### Per-Project Config

Create `.mise.toml` in project root:

```toml
[tools]
python = "3.11"  # Override global Python
node = "18"      # Use Node 18 for this project
```

Or use `.tool-versions` (asdf format):

```
python 3.11
node 18
```

### Common Commands

```bash
# List installed tools
mise list

# Install all tools from config
mise install

# Use specific version
mise use python@3.11

# Show current versions
mise current

# Update mise itself
mise self-update

# Validate configuration
mise doctor
```

## 🔍 Troubleshooting

### Serial Devices Not Accessible

```bash
# Check groups
groups | grep -E "uucp|lock"

# Add user to groups (requires logout)
sudo usermod -aG uucp,lock $USER

# Check udev rules
ls -la /etc/udev/rules.d/*arduino*

# Reload udev
sudo udevadm control --reload-rules
sudo udevadm trigger
```

### Mise Tool Not Found

```bash
# Verify mise is activated in shell
mise doctor

# Check if tool is in registry
mise registry

# Install specific backend
mise plugins install pipx
```

### Android Device Not Detected

```bash
# Check adb server
adb kill-server
adb start-server

# Verify udev rules
ls -la /etc/udev/rules.d/*android*

# Check USB debugging on device
adb devices
```

### Neovim Clipboard Not Working

```bash
# Install clipboard provider
sudo pacman -S xclip  # X11
sudo pacman -S wl-clipboard  # Wayland

# Verify in Neovim
:checkhealth
```

## 🚀 Workflows

### Python Project

```bash
cd ~/projects/my-python-project
mise use python@3.11
python -m venv .venv
source .venv/bin/activate
poetry install
```

### Node.js Project

```bash
cd ~/projects/my-node-project
mise use node@20
pnpm install
pnpm dev
```

### Arduino Project

```bash
cd ~/projects/my-esp32-project
arduino-cli compile --fqbn esp32:esp32:esp32
arduino-cli upload -p /dev/ttyUSB0 --fqbn esp32:esp32:esp32
```

### Android Project

```bash
cd ~/projects/my-android-app
./gradlew assembleDebug
adb install -r app/build/outputs/apk/debug/app-debug.apk
```

## 📚 Resources

- [Mise Documentation](https://mise.jdx.dev/)
- [Arduino CLI](https://arduino.github.io/arduino-cli/)
- [PlatformIO](https://platformio.org/)
- [Android Studio](https://developer.android.com/studio)
- [Neovim](https://neovim.io/)

## 🛠️ Maintenance

### Update All Tools

```bash
# Update mise
mise self-update

# Update installed tools
mise upgrade

# Update system packages
sudo pacman -Syu
```

### Cleanup

```bash
# Remove unused versions
mise prune

# Clear cache
mise cache clear
```

---

**Last Updated**: 2024-11-13  
**Version**: 2.0  
**Maintainer**: Sairu
