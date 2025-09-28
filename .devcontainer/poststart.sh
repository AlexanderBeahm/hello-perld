#!/bin/bash

echo "Startup script running..."

# Ensure Claude CLI is available for vscode user
echo "Checking Claude CLI availability..."

# Check if Claude CLI exists and is accessible
sudo -u vscode -i bash << 'EOF'
# Set up environment
export HOME=/home/vscode
cd $HOME

# Source .bashrc to get PATH updates
if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi

# Add npm global to PATH for this session
export PATH="$HOME/.npm-global/bin:$PATH"

# Check if Claude CLI is available
if [ -f "$HOME/.npm-global/bin/claude" ]; then
    echo "✓ Claude CLI binary found"
    echo "Claude CLI version: $($HOME/.npm-global/bin/claude --version)"
elif command -v claude >/dev/null 2>&1; then
    echo "✓ Claude CLI is available in PATH"
    echo "Claude CLI version: $(claude --version)"
else
    echo "⚠ Claude CLI not found. Checking installation..."
    echo "Contents of ~/.npm-global/bin/:"
    ls -la ~/.npm-global/bin/ 2>/dev/null || echo "Directory doesn't exist"
    echo "Current PATH: $PATH"
fi
EOF

# Update/create Claude configuration if API key is provided
if [ ! -z "$ANTHROPIC_API_KEY" ] && [ "$ANTHROPIC_API_KEY" != "your_api_key_here" ]; then
    echo "Updating Claude CLI configuration with API key..."
    mkdir -p /home/vscode/.config/claude

    # Copy configuration template and substitute API key
    sed "s/\${ANTHROPIC_API_KEY}/$ANTHROPIC_API_KEY/g" /workspaces/hello-perld/.claude/config.json > /home/vscode/.config/claude/config.json

    chmod 600 /home/vscode/.config/claude/config.json
    chown vscode:vscode /home/vscode/.config/claude/config.json
    echo "✓ Claude CLI configuration updated!"
else
    if [ ! -f "/home/vscode/.config/claude/config.json" ]; then
        echo "No API key provided and no existing configuration found."
        echo "To configure Claude CLI:"
        echo "1. Set ANTHROPIC_API_KEY in .env file and restart container"
        echo "2. Or run: claude auth login"
    else
        echo "✓ Using existing Claude CLI configuration"
    fi
fi

echo "✓ Startup script completed!"
