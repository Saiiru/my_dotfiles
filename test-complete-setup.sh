#!/usr/bin/env zsh
#═══════════════════════════════════════════════════════════════════════
# GOTHAM SYSTEM — Complete Setup Test
# Validates installation, symlinks, configs, and tools
#═══════════════════════════════════════════════════════════════════════

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Counters
TESTS_TOTAL=0
TESTS_PASSED=0
TESTS_FAILED=0

# Test result
test_result() {
    local name="$1"
    local test_status="$2"
    TESTS_TOTAL=$((TESTS_TOTAL + 1))
    
    if [[ $test_status -eq 0 ]]; then
        echo -e "${GREEN}✓${NC} $name"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo -e "${RED}✗${NC} $name"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
}

# Header
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  GOTHAM SYSTEM — HEALTH CHECK${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}\n"

#───────────────────────────────────────────────────────────────────────
# 1. DIRECTORY STRUCTURE
#───────────────────────────────────────────────────────────────────────
echo -e "${YELLOW}[1] Testing Directory Structure...${NC}"

[[ -d "$HOME/gotham" ]] && test_result "Gotham directory exists" 0 || test_result "Gotham directory exists" 1
[[ -d "$HOME/gotham/config" ]] && test_result "Config directory exists" 0 || test_result "Config directory exists" 1
[[ -d "$HOME/gotham/bin" ]] && test_result "Bin directory exists" 0 || test_result "Bin directory exists" 1
[[ -d "$HOME/gotham/themes" ]] && test_result "Themes directory exists" 0 || test_result "Themes directory exists" 1
[[ -d "$HOME/gotham/wallpapers" ]] && test_result "Wallpapers directory exists" 0 || test_result "Wallpapers directory exists" 1

#───────────────────────────────────────────────────────────────────────
# 2. ESSENTIAL FILES
#───────────────────────────────────────────────────────────────────────
echo -e "\n${YELLOW}[2] Testing Essential Files...${NC}"

[[ -f "$HOME/gotham/install.sh" ]] && test_result "install.sh exists" 0 || test_result "install.sh exists" 1
[[ -f "$HOME/gotham/symlink.sh" ]] && test_result "symlink.sh exists" 0 || test_result "symlink.sh exists" 1
[[ -f "$HOME/gotham/Justfile" ]] && test_result "Justfile exists" 0 || test_result "Justfile exists" 1
[[ -f "$HOME/gotham/mise.toml" ]] && test_result "mise.toml exists" 0 || test_result "mise.toml exists" 1
[[ -f "$HOME/gotham/themes/starship.toml" ]] && test_result "starship.toml exists" 0 || test_result "starship.toml exists" 1

#───────────────────────────────────────────────────────────────────────
# 3. SYMLINKS
#───────────────────────────────────────────────────────────────────────
echo -e "\n${YELLOW}[3] Testing Symlinks...${NC}"

[[ -L "$HOME/.zshrc" ]] && test_result "~/.zshrc symlink" 0 || test_result "~/.zshrc symlink" 1
[[ -L "$HOME/.config/zsh" ]] && test_result "~/.config/zsh symlink" 0 || test_result "~/.config/zsh symlink" 1
[[ -L "$HOME/.config/kitty" ]] && test_result "~/.config/kitty symlink" 0 || test_result "~/.config/kitty symlink" 1
[[ -L "$HOME/.config/tmux" ]] && test_result "~/.config/tmux symlink" 0 || test_result "~/.config/tmux symlink" 1
[[ -L "$HOME/.config/mise" ]] && test_result "~/.config/mise symlink" 0 || test_result "~/.config/mise symlink" 1
[[ -L "$HOME/.config/starship.toml" ]] && test_result "~/.config/starship.toml symlink" 0 || test_result "~/.config/starship.toml symlink" 1

#───────────────────────────────────────────────────────────────────────
# 4. ENVIRONMENT VARIABLES
#───────────────────────────────────────────────────────────────────────
echo -e "\n${YELLOW}[4] Testing Environment Variables...${NC}"

[[ -n "$GOTHAM_DIR" ]] && test_result "GOTHAM_DIR is set" 0 || test_result "GOTHAM_DIR is set" 1
[[ -n "$STARSHIP_CONFIG" ]] && test_result "STARSHIP_CONFIG is set" 0 || test_result "STARSHIP_CONFIG is set" 1
[[ -n "$EDITOR" ]] && test_result "EDITOR is set" 0 || test_result "EDITOR is set" 1

#───────────────────────────────────────────────────────────────────────
# 5. CORE TOOLS
#───────────────────────────────────────────────────────────────────────
echo -e "\n${YELLOW}[5] Testing Core Tools...${NC}"

command -v zsh &>/dev/null && test_result "zsh installed" 0 || test_result "zsh installed" 1
command -v git &>/dev/null && test_result "git installed" 0 || test_result "git installed" 1
command -v nvim &>/dev/null && test_result "neovim installed" 0 || test_result "neovim installed" 1
command -v tmux &>/dev/null && test_result "tmux installed" 0 || test_result "tmux installed" 1
command -v kitty &>/dev/null && test_result "kitty installed" 0 || test_result "kitty installed" 1
command -v starship &>/dev/null && test_result "starship installed" 0 || test_result "starship installed" 1
command -v mise &>/dev/null && test_result "mise installed" 0 || test_result "mise installed" 1
command -v just &>/dev/null && test_result "just installed" 0 || test_result "just installed" 1

#───────────────────────────────────────────────────────────────────────
# 6. OPTIONAL TOOLS
#───────────────────────────────────────────────────────────────────────
echo -e "\n${YELLOW}[6] Testing Optional Tools...${NC}"

command -v fzf &>/dev/null && test_result "fzf installed" 0 || test_result "fzf installed" 1
command -v eza &>/dev/null && test_result "eza installed" 0 || test_result "eza installed" 1
command -v bat &>/dev/null && test_result "bat installed" 0 || test_result "bat installed" 1
command -v fd &>/dev/null && test_result "fd installed" 0 || test_result "fd installed" 1
command -v rg &>/dev/null && test_result "ripgrep installed" 0 || test_result "ripgrep installed" 1
command -v lazygit &>/dev/null && test_result "lazygit installed" 0 || test_result "lazygit installed" 1

#───────────────────────────────────────────────────────────────────────
# 7. SCRIPTS IN PATH
#───────────────────────────────────────────────────────────────────────
echo -e "\n${YELLOW}[7] Testing Scripts in PATH...${NC}"

command -v backup.sh &>/dev/null && test_result "backup.sh in PATH" 0 || test_result "backup.sh in PATH" 1
command -v create-symlinks.sh &>/dev/null && test_result "create-symlinks.sh in PATH" 0 || test_result "create-symlinks.sh in PATH" 1

#───────────────────────────────────────────────────────────────────────
# 8. CONFIGURATION VALIDITY
#───────────────────────────────────────────────────────────────────────
echo -e "\n${YELLOW}[8] Testing Configuration Validity...${NC}"

# Test ZSH config syntax
if zsh -n "$HOME/gotham/config/zsh/zshrc" 2>/dev/null; then
    test_result "zshrc syntax valid" 0
else
    test_result "zshrc syntax valid" 1
fi

# Test starship config
if starship config 2>/dev/null | grep -q "starship"; then
    test_result "starship config valid" 0
else
    test_result "starship config valid" 1
fi

# Test mise config
if [[ -f "$HOME/gotham/mise.toml" ]]; then
    test_result "mise.toml readable" 0
else
    test_result "mise.toml readable" 1
fi

#───────────────────────────────────────────────────────────────────────
# SUMMARY
#───────────────────────────────────────────────────────────────────────
echo -e "\n${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  TEST RESULTS${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo -e "Total Tests:  ${TESTS_TOTAL}"
echo -e "${GREEN}Passed:       ${TESTS_PASSED}${NC}"
echo -e "${RED}Failed:       ${TESTS_FAILED}${NC}"

if [[ $TESTS_FAILED -eq 0 ]]; then
    echo -e "\n${GREEN}✅ All tests passed! Gotham system is healthy.${NC}\n"
    exit 0
else
    echo -e "\n${YELLOW}⚠️  Some tests failed. Review the results above.${NC}\n"
    exit 1
fi
