#═══════════════════════════════════════════════════════════════════════
# GOTHAM SYSTEM — Just Task Runner
# Command center for all development and system tasks
#═══════════════════════════════════════════════════════════════════════

# Set shell
set shell := ["zsh", "-cu"]

# Default recipe (show help)
default:
    @just --list --unsorted

#───────────────────────────────────────────────────────────────────────
# 🚀 INSTALLATION & SETUP
#───────────────────────────────────────────────────────────────────────

# Install complete Gotham system
install:
    @echo "🚀 Installing Gotham System..."
    ./install.sh

# Create all symlinks
symlink:
    @echo "🔗 Creating symlinks..."
    ./symlink.sh

# Reinstall (clean + install)
reinstall: clean install

# Quick symlink creation
quick-symlink:
    @echo "⚡ Quick symlink setup..."
    bin/system/create-symlinks.sh

#───────────────────────────────────────────────────────────────────────
# 📦 PACKAGE MANAGEMENT
#───────────────────────────────────────────────────────────────────────

# Update system packages
update:
    @echo "📦 Updating system packages..."
    sudo pacman -Syu

# Install all development tools via mise
install-dev-tools:
    @echo "🛠️  Installing development tools..."
    mise install

# Update mise tools
update-dev-tools:
    @echo "🔄 Updating mise tools..."
    mise upgrade

# List installed mise tools
list-tools:
    @echo "📋 Installed tools:"
    mise list

#───────────────────────────────────────────────────────────────────────
# 🔧 SYSTEM MANAGEMENT
#───────────────────────────────────────────────────────────────────────

# Backup current configuration
backup:
    @echo "💾 Creating backup..."
    bin/system/backup.sh

# Clean temporary files and caches
clean:
    @echo "🧹 Cleaning..."
    rm -rf ~/.cache/zsh/*
    rm -rf ~/.zcompdump*
    rm -f ~/.zshrc.zwc
    find config/zsh -name "*.zwc" -delete
    @echo "✅ Cache cleaned"

# Reload shell configuration
reload:
    @echo "🔄 Reloading shell..."
    exec zsh

# Check system health
health:
    @echo "🏥 System Health Check:"
    @just test

# Run complete system test
test:
    @echo "🧪 Running tests..."
    ./test-complete-setup.sh

#───────────────────────────────────────────────────────────────────────
# 🎨 THEMING & UI
#───────────────────────────────────────────────────────────────────────

# Change wallpaper
wallpaper:
    @echo "🖼️  Changing wallpaper..."
    bin/system/change-wallpaper.sh

# Apply color scheme
colors:
    @echo "🎨 Applying colors..."
    bin/theme/colors-apply.sh

# Toggle waybar visibility
waybar:
    @echo "📊 Toggling waybar..."
    bin/system/toggle-waybar.sh

#───────────────────────────────────────────────────────────────────────
# ⚡ POWER MANAGEMENT
#───────────────────────────────────────────────────────────────────────

# Change power profile (performance/balanced/power-save)
power-profile profile:
    @echo "⚡ Changing power profile to {{profile}}..."
    bin/system/change-power-profile.sh {{profile}}

# Set idle timeout (in minutes)
idle-time minutes:
    @echo "⏰ Setting idle time to {{minutes}} minutes..."
    bin/system/change-idle-time.sh {{minutes}}

# Lock screen
lock:
    @echo "🔒 Locking screen..."
    bin/system/swaylock.sh

#───────────────────────────────────────────────────────────────────────
# 🔋 BATTERY MANAGEMENT
#───────────────────────────────────────────────────────────────────────

# Install battery manager
battery-install:
    @echo "🔋 Installing battery manager..."
    bin/battery/install-battery-manager.sh

# Set battery charge threshold (20-100)
battery-threshold percent:
    @echo "🔋 Setting battery threshold to {{percent}}%..."
    bin/battery/set-battery-treshold.sh {{percent}}

#───────────────────────────────────────────────────────────────────────
# 🐍 PYTHON DEVELOPMENT
#───────────────────────────────────────────────────────────────────────

# Create Python virtual environment
py-venv name="venv":
    @echo "🐍 Creating Python venv: {{name}}..."
    python -m venv {{name}}
    @echo "✅ Activate with: source {{name}}/bin/activate"

# Install Python dependencies from requirements.txt
py-install:
    @echo "📦 Installing Python dependencies..."
    pip install -r requirements.txt

# Format Python code with black
py-format:
    @echo "✨ Formatting Python code..."
    black .

# Lint Python code with ruff
py-lint:
    @echo "🔍 Linting Python code..."
    ruff check .

# Type check with mypy
py-type:
    @echo "🔎 Type checking..."
    mypy .

# Run Python tests
py-test:
    @echo "🧪 Running Python tests..."
    pytest

#───────────────────────────────────────────────────────────────────────
# 📦 NODE.JS DEVELOPMENT
#───────────────────────────────────────────────────────────────────────

# Install Node dependencies
node-install:
    @echo "📦 Installing Node dependencies..."
    pnpm install

# Build Node project
node-build:
    @echo "🔨 Building Node project..."
    pnpm build

# Run Node dev server
node-dev:
    @echo "🚀 Starting dev server..."
    pnpm dev

# Run Node tests
node-test:
    @echo "🧪 Running Node tests..."
    pnpm test

# Lint JavaScript/TypeScript
node-lint:
    @echo "🔍 Linting code..."
    pnpm lint

# Format JavaScript/TypeScript
node-format:
    @echo "✨ Formatting code..."
    pnpm format

#───────────────────────────────────────────────────────────────────────
# 🦀 RUST DEVELOPMENT
#───────────────────────────────────────────────────────────────────────

# Build Rust project
rust-build:
    @echo "🔨 Building Rust project..."
    cargo build

# Build Rust release
rust-release:
    @echo "🚀 Building release..."
    cargo build --release

# Run Rust project
rust-run:
    @echo "▶️  Running Rust project..."
    cargo run

# Test Rust project
rust-test:
    @echo "🧪 Running Rust tests..."
    cargo test

# Format Rust code
rust-format:
    @echo "✨ Formatting Rust code..."
    cargo fmt

# Lint Rust code
rust-lint:
    @echo "🔍 Linting Rust code..."
    cargo clippy

#───────────────────────────────────────────────────────────────────────
# ☕ JAVA DEVELOPMENT
#───────────────────────────────────────────────────────────────────────

# Build Maven project
mvn-build:
    @echo "🔨 Building Maven project..."
    mvn clean install

# Run Maven tests
mvn-test:
    @echo "🧪 Running Maven tests..."
    mvn test

# Build Gradle project
gradle-build:
    @echo "🔨 Building Gradle project..."
    gradle build

# Run Gradle tests
gradle-test:
    @echo "🧪 Running Gradle tests..."
    gradle test

#───────────────────────────────────────────────────────────────────────
# 🐳 DOCKER & CONTAINERS
#───────────────────────────────────────────────────────────────────────

# Build Docker image
docker-build name tag="latest":
    @echo "🐳 Building Docker image: {{name}}:{{tag}}..."
    docker build -t {{name}}:{{tag}} .

# Run Docker compose
docker-up:
    @echo "🚀 Starting Docker Compose..."
    docker-compose up -d

# Stop Docker compose
docker-down:
    @echo "🛑 Stopping Docker Compose..."
    docker-compose down

# View Docker logs
docker-logs:
    @echo "📋 Docker logs..."
    docker-compose logs -f

# Clean Docker (remove stopped containers, unused images)
docker-clean:
    @echo "🧹 Cleaning Docker..."
    docker system prune -f

#───────────────────────────────────────────────────────────────────────
# ☸️  KUBERNETES
#───────────────────────────────────────────────────────────────────────

# Get Kubernetes pods
k8s-pods:
    @echo "📋 Kubernetes pods:"
    kubectl get pods

# Get Kubernetes services
k8s-services:
    @echo "📋 Kubernetes services:"
    kubectl get services

# Apply Kubernetes manifests
k8s-apply file:
    @echo "📤 Applying {{file}}..."
    kubectl apply -f {{file}}

# Get logs from pod
k8s-logs pod:
    @echo "📋 Logs from {{pod}}:"
    kubectl logs -f {{pod}}

#───────────────────────────────────────────────────────────────────────
# 🔍 GIT & VERSION CONTROL
#───────────────────────────────────────────────────────────────────────

# Git status
status:
    @git status

# Git commit with message
commit msg:
    @git add -A
    @git commit -m "{{msg}}"

# Git push
push:
    @git push

# Quick commit and push
save msg:
    @just commit "{{msg}}"
    @just push

# Show git log
log:
    @git --no-pager log --oneline -10

#───────────────────────────────────────────────────────────────────────
# 📊 MONITORING & INFO
#───────────────────────────────────────────────────────────────────────

# Show system info
info:
    @echo "════════════════════════════════════════"
    @echo "GOTHAM SYSTEM INFO"
    @echo "════════════════════════════════════════"
    @echo "Kernel: $(uname -r)"
    @echo "Shell: $SHELL"
    @echo "Editor: $EDITOR"
    @echo "Gotham: $GOTHAM_DIR"
    @echo ""
    @echo "Development Tools:"
    @mise list
    @echo ""
    @echo "System Resources:"
    @free -h | grep "Mem:"
    @df -h / | tail -1

# Show keybindings
keys:
    @echo "📝 Opening keybindings documentation..."
    @cat docs/KEYBINDINGS.md 2>/dev/null || echo "Documentation not created yet"

# Show all available commands
help:
    @just --list

#───────────────────────────────────────────────────────────────────────
# 📝 DOCUMENTATION
#───────────────────────────────────────────────────────────────────────

# Generate documentation
docs-generate:
    @echo "📝 Generating documentation..."
    @echo "TODO: Implement documentation generation"

# Open documentation
docs:
    @echo "📖 Opening documentation..."
    @bat docs/README.md 2>/dev/null || echo "Documentation not found"
