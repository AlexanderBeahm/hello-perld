#!/bin/bash

echo "=== Claude CLI Installation Test ==="

# Test 1: Check if running as vscode user
echo "Current user: $(whoami)"
if [ "$(whoami)" != "vscode" ]; then
    echo "⚠ Not running as vscode user. Run as: sudo -u vscode bash ./.devcontainer/test-claude.sh"
fi

# Test 2: Check npm configuration
echo ""
echo "=== NPM Configuration ==="
npm config get prefix
echo "NPM global directory contents:"
ls -la ~/.npm-global/bin/ 2>/dev/null || echo "Directory doesn't exist"

# Test 3: Check PATH
echo ""
echo "=== PATH Configuration ==="
echo "Current PATH: $PATH"
echo "PATH includes npm-global: $(echo $PATH | grep -q npm-global && echo "✓ YES" || echo "✗ NO")"

# Test 4: Check Claude CLI binary
echo ""
echo "=== Claude CLI Binary ==="
if [ -f "$HOME/.npm-global/bin/claude" ]; then
    echo "✓ Claude CLI binary found at ~/.npm-global/bin/claude"
    ls -la ~/.npm-global/bin/claude
else
    echo "✗ Claude CLI binary not found at ~/.npm-global/bin/claude"
fi

# Test 5: Test Claude CLI execution
echo ""
echo "=== Claude CLI Execution Test ==="
if [ -f "$HOME/.npm-global/bin/claude" ]; then
    echo "Testing direct path execution:"
    $HOME/.npm-global/bin/claude --version 2>&1
elif command -v claude >/dev/null 2>&1; then
    echo "Testing PATH execution:"
    claude --version 2>&1
else
    echo "✗ Claude CLI not executable from any method"
fi

# Test 6: Check configuration
echo ""
echo "=== Claude Configuration ==="
if [ -f "$HOME/.config/claude/config.json" ]; then
    echo "✓ Configuration file exists"
    echo "Configuration file permissions: $(ls -la ~/.config/claude/config.json | cut -d' ' -f1)"
    echo "Has API key: $(grep -q api_key ~/.config/claude/config.json && echo "✓ YES" || echo "✗ NO")"
else
    echo "✗ No configuration file found at ~/.config/claude/config.json"
fi

# Test 7: Environment variables
echo ""
echo "=== Environment Variables ==="
echo "ANTHROPIC_API_KEY set: $([ ! -z "$ANTHROPIC_API_KEY" ] && echo "✓ YES" || echo "✗ NO")"
if [ ! -z "$ANTHROPIC_API_KEY" ] && [ ${#ANTHROPIC_API_KEY} -gt 20 ]; then
    echo "API key format looks valid (length: ${#ANTHROPIC_API_KEY})"
else
    echo "API key may be missing or invalid"
fi

echo ""
echo "=== Test Complete ==="
echo "If Claude CLI is not working:"
echo "1. Try: source ~/.bashrc"
echo "2. Try: sudo -u vscode -i bash ./.devcontainer/setup-claude.sh"
echo "3. Try using full path: ~/.npm-global/bin/claude"