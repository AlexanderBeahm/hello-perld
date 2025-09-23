# Claude Code Integration Setup

This devcontainer is configured to automatically install and configure Claude CLI for seamless AI assistance.

## Setup Instructions

1. **Copy the environment template:**
   ```bash
   cp .env.template .env
   ```

2. **Add your Anthropic API Key to `.env`:**
   ```bash
   ANTHROPIC_API_KEY=your_actual_api_key_here
   ```

3. **Make scripts executable (if needed):**
   ```bash
   chmod +x .devcontainer/postcreate.sh .devcontainer/poststart.sh
   ```

4. **Build/Rebuild your devcontainer** in VS Code

## What Gets Installed

- **Node.js LTS** via devcontainer feature
- **Claude CLI** (`@anthropic-ai/claude-cli`) installed globally for vscode user
- **Automatic configuration** if API key is provided in `.env`

## Usage

Once the container is built and started, you can use Claude CLI directly:

```bash
# Check installation
claude --version

# Start a conversation
claude chat

# Get help with code
claude code-review ./path/to/file

# Ask questions
claude ask "How do I optimize this Perl script?"
```

## Configuration

- Configuration is stored in `/home/vscode/.config/claude/config.json`
- Claude CLI is added to PATH automatically for the vscode user
- API key is loaded from environment variables on container start

## Troubleshooting

### Claude CLI not found
```bash
# Test your installation
sudo -u vscode bash ./.devcontainer/test-claude.sh

# Try reloading your shell
source ~/.bashrc

# Or use the full path
~/.npm-global/bin/claude --version

# Manual setup if needed
sudo -u vscode -i bash ./.devcontainer/setup-claude.sh
```

### PATH Issues
```bash
# Check if npm-global is in PATH
echo $PATH | grep npm-global

# Manually add to current session
export PATH="$HOME/.npm-global/bin:$PATH"

# Ensure it's in .bashrc
grep npm-global ~/.bashrc
```

### Configuration Issues
```bash
# Check configuration
ls -la ~/.config/claude/

# Remove and recreate config
rm -f ~/.config/claude/config.json
sudo ./.devcontainer/poststart.sh

# Or manually configure
claude auth login
```

### VS Code Tasks
Use Command Palette (Ctrl+Shift+P):
- "Tasks: Run Task" → "Test Claude CLI" (comprehensive test)
- "Tasks: Run Task" → "Setup Claude CLI" (manual setup)
- "Tasks: Run Task" → "Quick Claude Version Check" (quick test)
