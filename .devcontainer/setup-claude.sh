#!/bin/bash

# Manual setup script for Claude CLI if automatic setup fails

echo "Manual Claude CLI setup script..."

# Ensure we're running as vscode user
if [ "$(whoami)" != "vscode" ]; then
    echo "This script should be run as the vscode user"
    echo "Run: sudo -u vscode -i bash ./.devcontainer/setup-claude.sh"
    exit 1
fi

# Set up environment
export HOME=/home/vscode
cd $HOME

# Set up npm global directory
mkdir -p ~/.npm-global
npm config set prefix '~/.npm-global'

# Add to PATH in .bashrc if not already there
if ! grep -q "npm-global" ~/.bashrc; then
    echo "" >> ~/.bashrc
    echo "# NPM Global packages" >> ~/.bashrc
    echo "export PATH=~/.npm-global/bin:\$PATH" >> ~/.bashrc
fi

# Set PATH for current session
export PATH="$HOME/.npm-global/bin:$PATH"

# Install Claude CLI
echo "Installing Claude CLI..."
npm install -g @anthropic-ai/claude-cli

# Create config directory
mkdir -p ~/.config/claude

# Configure if API key is available
if [ ! -z "$ANTHROPIC_API_KEY" ] && [ "$ANTHROPIC_API_KEY" != "your_api_key_here" ]; then
    echo "Configuring Claude CLI with API key..."
    cat > ~/.config/claude/config.json << EOL
{
  "api_key": "$ANTHROPIC_API_KEY",
  "default_model": "claude-3-5-sonnet-20241022"
}
EOL
    chmod 600 ~/.config/claude/config.json
    echo "✓ Claude CLI configured with API key!"
else
    echo "⚠ No API key found in ANTHROPIC_API_KEY environment variable"
    echo "You can configure it later by running: claude auth login"
fi

# Test installation
echo "Testing Claude CLI..."
if [ -f "$HOME/.npm-global/bin/claude" ]; then
    echo "✓ Claude CLI installed successfully!"
    $HOME/.npm-global/bin/claude --version
    echo "Claude CLI is available at: $HOME/.npm-global/bin/claude"
elif command -v claude >/dev/null 2>&1; then
    echo "✓ Claude CLI found in PATH!"
    claude --version
else
    echo "⚠ Claude CLI not found. Debugging info:"
    echo "  Contents of ~/.npm-global/bin/:"
    ls -la ~/.npm-global/bin/ 2>/dev/null || echo "  Directory doesn't exist"
    echo "  Current PATH: $PATH"
    echo "  You may need to:"
    echo "    1. Reload your shell: source ~/.bashrc"
    echo "    2. Or restart your terminal"
    echo "    3. Or use full path: ~/.npm-global/bin/claude"
fi

echo "Setup complete! Reload your shell or start a new terminal to use Claude CLI."