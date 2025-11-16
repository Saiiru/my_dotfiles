#!/usr/bin/env zsh
#═══════════════════════════════════════════════════════════════════════
# WORKSTATION OPS — Complete Setup Test
# Validates installation, symlinks, configs, and tooling
#═══════════════════════════════════════════════════════════════════════

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

WORKSTATION_DIR="${WORKSTATION_DIR:-$HOME/workstation}"

TESTS_TOTAL=0
TESTS_PASSED=0
TESTS_FAILED=0

print_result() {
    local name="$1" rc="$2"
    TESTS_TOTAL=$(( TESTS_TOTAL + 1 ))
    if [[ $rc -eq 0 ]]; then
        echo -e "${GREEN}✓${NC} $name"
        TESTS_PASSED=$(( TESTS_PASSED + 1 ))
    else
        echo -e "${RED}✗${NC} $name"
        TESTS_FAILED=$(( TESTS_FAILED + 1 ))
    fi
}

section() {
    echo -e "\n${YELLOW}[$1]${NC}"
}

echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  WORKSTATION OPS — HEALTH CHECK${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}\n"

# 1. Directory structure
section "1 · Directory Structure"
declare -a dirs=(
    "$WORKSTATION_DIR"
    "$WORKSTATION_DIR/config"
    "$WORKSTATION_DIR/install"
    "$WORKSTATION_DIR/docs"
    "$WORKSTATION_DIR/fonts"
    "$WORKSTATION_DIR/themes"
    "$WORKSTATION_DIR/wallpapers"
    "$WORKSTATION_DIR/scripts"
)
for dir in "${dirs[@]}"; do
    [[ -d "$dir" ]]
    print_result "$dir" $?
done

# 2. Essential files
section "2 · Essential Files"
declare -a files=(
    "$WORKSTATION_DIR/install/install.sh"
    "$WORKSTATION_DIR/install/symlinks-only.sh"
    "$WORKSTATION_DIR/install/modules/packages.sh"
    "$WORKSTATION_DIR/install/modules/symlinks.sh"
    "$WORKSTATION_DIR/install/modules/tmux.sh"
    "$WORKSTATION_DIR/install/modules/zsh.sh"
    "$WORKSTATION_DIR/Justfile"
    "$WORKSTATION_DIR/mise.toml"
    "$WORKSTATION_DIR/themes/starship.toml"
)
for file in "${files[@]}"; do
    [[ -f "$file" ]]
    print_result "$file" $?
done

# 3. Symlinks
section "3 · Symlinks"
declare -a links=(
    "$HOME/.zshrc"
    "$HOME/.config/zsh"
    "$HOME/.config/kitty"
    "$HOME/.config/ghostty"
    "$HOME/.config/tmux"
    "$HOME/.config/mise"
    "$HOME/.config/niri"
    "$HOME/.config/wlogout"
    "$HOME/.config/quickshell"
    "$HOME/.config/systemd"
    "$HOME/.config/pipewire"
    "$HOME/.config/starship.toml"
)
for link in "${links[@]}"; do
    [[ -L "$link" ]]
    print_result "$link" $?
done

# 4. Tooling
section "4 · Tooling"
declare -a tools=(zsh tmux nvim mise)
for tool in "${tools[@]}"; do
    command -v "$tool" &>/dev/null
    print_result "$tool available" $?
done

if [[ -d "$HOME/.tmux/plugins/tpm" ]]; then
    print_result "tmux TPM present" 0
else
    print_result "tmux TPM present" 1
fi

# 5. Configuration sanity
section "5 · Configuration"
[[ -n "$WORKSTATION_DIR" ]]
print_result "WORKSTATION_DIR set" $?
[[ -f "$WORKSTATION_DIR/themes/starship.toml" ]]
print_result "starship theme" $?
[[ -s "$WORKSTATION_DIR/mise.toml" ]]
print_result "mise config" $?

# Summary

echo -e "\n${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  TEST RESULTS${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo -e "Total Tests:  ${TESTS_TOTAL}"
echo -e "${GREEN}Passed:       ${TESTS_PASSED}${NC}"
echo -e "${RED}Failed:       ${TESTS_FAILED}${NC}"

if [[ $TESTS_FAILED -eq 0 ]]; then
    echo -e "\n${GREEN}✅ All tests passed! Workstation is healthy.${NC}\n"
    exit 0
else
    echo -e "\n${YELLOW}⚠️  Some tests failed. Review the sections above.${NC}\n"
    exit 1
fi
