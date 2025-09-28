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

echo "✓ Startup script completed!"
