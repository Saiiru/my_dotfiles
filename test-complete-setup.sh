#!/usr/bin/env zsh
echo "🧪 TESTE COMPLETO DO GOTHAM SYSTEM"
echo "══════════════════════════════════════════════════════════════"
echo ""

# Test 1: Symlinks
echo "1️⃣  TESTANDO SYMLINKS..."
ERRORS=0

test_symlink() {
    local link="$1"
    local desc="$2"
    if [[ -L "$link" ]]; then
        local target=$(readlink -f "$link")
        if [[ -e "$target" ]]; then
            echo "   ✅ $desc: $link → $target"
        else
            echo "   ❌ $desc: target não existe!"
            ((ERRORS++))
        fi
    else
        echo "   ❌ $desc: não é symlink!"
        ((ERRORS++))
    fi
}

test_symlink ~/.zshrc ".zshrc"
test_symlink ~/.config/zsh "zsh config"
test_symlink ~/.config/kitty "kitty config"
test_symlink ~/.config/tmux "tmux config"
test_symlink ~/.config/starship.toml "starship config"

echo ""
echo "2️⃣  TESTANDO ARQUIVOS CRÍTICOS..."

test_file() {
    local file="$1"
    local desc="$2"
    if [[ -f "$file" ]]; then
        echo "   ✅ $desc existe"
    else
        echo "   ❌ $desc NÃO EXISTE!"
        ((ERRORS++))
    fi
}

test_file ~/gotham/themes/starship.toml "Starship theme"
test_file ~/gotham/config/zsh/zshrc "ZSH config"
test_file ~/gotham/config/zsh/plugins/00-init.zsh "Znap init"
test_file ~/gotham/install.sh "Install script"
test_file ~/gotham/symlink.sh "Symlink script"

echo ""
echo "3️⃣  TESTANDO COMANDOS NO PATH..."

test_in_path() {
    local dir="$1"
    if echo "$PATH" | grep -q "$dir"; then
        echo "   ✅ $dir está no PATH"
    else
        echo "   ❌ $dir NÃO está no PATH!"
        ((ERRORS++))
    fi
}

export GOTHAM_DIR="$HOME/gotham"
source ~/gotham/config/zsh/core/00-environment.zsh 2>/dev/null

test_in_path "gotham/bin/system"
test_in_path "gotham/bin/battery"
test_in_path "gotham/bin/theme"

echo ""
echo "4️⃣  TESTANDO VARIÁVEIS DE AMBIENTE..."

test_var() {
    local var="$1"
    local expected="$2"
    local actual="${(P)var}"
    if [[ -n "$actual" ]]; then
        if [[ "$actual" == *"$expected"* ]]; then
            echo "   ✅ $var está correto"
        else
            echo "   ⚠️  $var = $actual (esperado: *$expected*)"
        fi
    else
        echo "   ❌ $var não está definido!"
        ((ERRORS++))
    fi
}

test_var GOTHAM_DIR "gotham"
test_var STARSHIP_CONFIG "themes/starship.toml"
test_var EDITOR "nvim"

echo ""
echo "5️⃣  TESTANDO FERRAMENTAS INSTALADAS..."

test_command() {
    local cmd="$1"
    if command -v "$cmd" >/dev/null 2>&1; then
        echo "   ✅ $cmd instalado"
    else
        echo "   ⚠️  $cmd não instalado (opcional)"
    fi
}

test_command zsh
test_command starship
test_command kitty
test_command tmux
test_command fzf
test_command eza
test_command bat
test_command fd
test_command rg
test_command zoxide
test_command mise
test_command just

echo ""
echo "══════════════════════════════════════════════════════════════"
if [[ $ERRORS -eq 0 ]]; then
    echo "✅ TODOS OS TESTES PASSARAM!"
    exit 0
else
    echo "❌ $ERRORS ERRO(S) ENCONTRADO(S)"
    exit 1
fi
