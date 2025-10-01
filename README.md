# hello-perld

A simple perl server with containerization and VSCode dev container support.

[![Docker Image CI](https://github.com/AlexanderBeahm/hello-perld/actions/workflows/docker-image.yml/badge.svg)](https://github.com/AlexanderBeahm/hello-perld/actions/workflows/docker-image.yml)

# Features
- Lightweight Perl web server w/ [Mojolicious](https://docs.mojolicious.org/)
- Vue 3 SPA frontend with Vite build system
- OpenAPI schema support w/ Swagger page.
- Multiple logging schemes available out of box.
- PostgreSQL database integration.
- DevContainer support w/ external Docker containerization.
- Integrated Claude Code support.

# Prerequisites
- **Node.js LTS** (for frontend development)
- **Docker & Docker Compose**
- **VSCode** (recommended for DevContainer support)

# Setup

## DevContainer Setup (Recommended)
1. Open repository with VSCode `code .`
2. Use VSCode command 'Open Folder In Container...'
3. Wait until postcreate.sh and poststart.sh are completed (installs dependencies and builds frontend)
4. Run `docker compose up --build --watch`
5. "Hello, perld!" will be served at localhost:3000, with swagger frontend at localhost:3000/swagger

## Local Development Setup
1. **Install Perl dependencies:**
   ```bash
   cpanm --installdeps --notest .
   ```

2. **Install frontend dependencies and build:**
   ```bash
   cd frontend
   npm install
   npm run build
   cd ..
   ```

3. **Start the Mojolicious server:**
   ```bash
   morbo ./script/hello-perld
   ```
   The application will be available at http://localhost:3000

## Docker Production Setup
```bash
docker compose up --build
```

# Development Workflow

## Frontend Development
The frontend is a Vue 3 single-page application built with Vite.

### Development Mode (with Hot Module Replacement)
For the best development experience, run the Vite dev server and Mojolicious backend separately:

1. **Terminal 1 - Start Mojolicious backend:**
   ```bash
   morbo ./script/hello-perld
   ```

2. **Terminal 2 - Start Vite dev server:**
   ```bash
   cd frontend
   npm run dev
   ```
   The Vite dev server runs at http://localhost:5173 and proxies API calls to the Mojolicious backend at http://localhost:3000

### Production Build
To build the frontend for production:
```bash
cd frontend
npm run build
```
This builds assets to `lib/HelloPerld/Public/dist/` which are served by Mojolicious.

## Project Structure
```
hello-perld/
├── frontend/                    # Vue 3 SPA frontend
│   ├── src/
│   │   ├── components/         # Vue components
│   │   ├── views/              # Page views
│   │   ├── router/             # Vue Router config
│   │   ├── assets/             # CSS and static assets
│   │   ├── App.vue             # Root component
│   │   └── main.js             # Entry point
│   ├── index.html              # HTML template
│   ├── vite.config.js          # Vite configuration
│   └── package.json            # Frontend dependencies
├── lib/HelloPerld/             # Perl backend
│   ├── Public/                 # Static assets
│   │   └── dist/               # Built frontend assets (generated)
│   └── Templates/              # Mojolicious templates
├── script/                     # Perl scripts
└── Dockerfile                  # Multi-stage build (Node + Perl)

---
## ssh-agent Setup (for use with Git SSH within Dev Container)
### Prep WSL2 (Ubuntu/Debian shown—adapt as needed), Ensure OpenSSH client & ssh-agent
```
sudo apt-get update
sudo apt-get install -y openssh-client
```

### Start (and persist) an ssh-agent in WSL2

Put this tiny helper in your shell init so a single socket lives across sessions:

### Add to ~/.bashrc (or ~/.zshrc)
```
if [ -z "$SSH_AUTH_SOCK" ]; then
  SOCK="$HOME/.ssh/agent.sock"
  if [ -S "$SOCK" ]; then
    export SSH_AUTH_SOCK="$SOCK"
  else
    mkdir -p "$HOME/.ssh"
    eval "$(ssh-agent -a "$SOCK" -s)" >/dev/null
    export SSH_AUTH_SOCK="$SOCK"
  fi
fi
```

Reload your shell:

`exec $SHELL -l`

### Add your key to the agent
```
ssh-add ~/.ssh/id_ed25519
# or: ssh-add ~/.ssh/id_rsa
ssh-add -l    # should list your key fingerprint
```


Tip: First confirm this works directly in WSL:
```
ssh -T git@github.com
```
### Expect: "Hi <username>! You've successfully authenticated..."


If that succeeds, your host (WSL2) SSH is good.

### Validate in dev container

Open the folder in WSL (VS Code: “Open Folder in WSL”), then Reopen in Container.

Inside the container’s terminal:
```
echo "$SSH_AUTH_SOCK"       # should be /ssh-agent
ls -l "$SSH_AUTH_SOCK"      # should be a socket file
ssh -T git@github.com       # should greet you (no password prompt)
```

Ensure the repo remote uses SSH, not HTTPS:
```
git remote -v
git remote set-url origin git@github.com:<org>/<repo>.git
```

git fetch, git pull, git push should now work from inside the dev container.

## Common issues & fixes
“Permission denied (publickey)”

In WSL (not container): `ssh-add -l` must list your key. If empty, `ssh-add ~/.ssh/<yourkey>`.

Inside container: `echo $SSH_AUTH_SOCK` should be /ssh-agent and `ls -l /ssh-agent` should show a socket.

Ensure devcontainer.json used `${localEnv:SSH_AUTH_SOCK}` (not ${env:...}) so it resolves in the WSL VS Code context.

If that fails, it may be possible that there are multiple agents available and that is causing a conflict in forwarding the correct one.

### In WSL2: run one pinned ssh-agent and load keys

Put the agent on a stable path so VS Code always mounts the same socket.

### In WSL2
```
pkill ssh-agent 2>/dev/null || true
rm -f ~/.ssh/agent.sock
eval "$(ssh-agent -a "$HOME/.ssh/agent.sock" -s)"
ssh-add -D
ssh-add ~/.ssh/id_ed25519  # or your key file
ssh-add -l                 # should list your key(s)
```

Verify you’re using the pinned agent:
```
SSH_AUTH_SOCK=$HOME/.ssh/agent.sock ssh-add -l   # must list the same keys
echo "$SSH_AUTH_SOCK"                            # ideally /home/<you>/.ssh/agent.sock
```
