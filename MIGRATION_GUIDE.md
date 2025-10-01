# Vue.js Build System Migration Guide

This document outlines the changes made to integrate a full Vue.js build system into HelloPerld.

## Summary of Changes

The application has been upgraded from a CDN-based Vue.js integration to a full Vue 3 + Vite build system with Single File Components (SFCs), Vue Router, and proper asset bundling.

## What Changed

### 1. Frontend Structure
**Before:** Vue.js was loaded from CDN with inline templates in `index.html.ep`

**After:** Complete Vue 3 application with:
- `frontend/` directory containing the full Vue.js SPA
- Vite as the build tool
- Vue Router for navigation
- Single File Components (`.vue` files)
- Proper asset bundling and optimization

### 2. File Changes

#### New Files Created
```
frontend/
├── src/
│   ├── components/
│   │   └── NavBar.vue           # Navigation component
│   ├── views/
│   │   ├── HomePage.vue         # Home page view
│   │   └── AboutPage.vue        # About page view
│   ├── router/
│   │   └── index.js             # Vue Router configuration
│   ├── assets/
│   │   └── index.css            # Global styles
│   ├── App.vue                  # Root component
│   └── main.js                  # Application entry point
├── index.html                   # HTML template
├── vite.config.js              # Vite configuration
└── package.json                # Frontend dependencies

build.sh                        # Build script
.dockerignore                   # Docker ignore file
```

#### Modified Files
- `lib/HelloPerld.pm` - Updated to serve built assets and handle `.map`, `.mjs` files
- `lib/HelloPerld/Templates/index.html.ep` - Kept as fallback template
- `.devcontainer/devcontainer.json` - Added Vue.js VSCode extensions
- `.devcontainer/postcreate.sh` - Added frontend build steps
- `Dockerfile` - Multi-stage build with Node.js
- `docker-compose.yml` - Updated watch configuration
- `.gitignore` - Added frontend build artifacts
- `README.md` - Updated with new build instructions

### 3. Technology Stack

#### Added Dependencies
- **Frontend:**
  - Vue 3.4.21
  - Vue Router 4.3.0
  - Vite 5.1.6
  - @vitejs/plugin-vue 5.0.4

#### VSCode Extensions
- `Vue.volar` - Vue 3 language support
- `Vue.vscode-typescript-vue-plugin` - TypeScript support for Vue
- `dbaeumer.vscode-eslint` - ESLint integration

### 4. Build Process

#### Development Workflow
Two options:

**Option 1: Production Mode (Single Server)**
```bash
cd frontend && npm run build && cd ..
morbo ./script/hello-perld
```
Access at: http://localhost:3000

**Option 2: Development Mode (Dual Server with HMR)**
```bash
# Terminal 1: Backend
morbo ./script/hello-perld

# Terminal 2: Frontend with Hot Module Replacement
cd frontend && npm run dev
```
Access at: http://localhost:5173 (proxies API calls to :3000)

#### Production Build
```bash
./build.sh
# or
cd frontend && npm install && npm run build
```

### 5. Docker Changes

#### Multi-Stage Build
The Dockerfile now uses a multi-stage build:
1. **Stage 1:** Node.js Alpine builds the Vue.js frontend
2. **Stage 2:** Perl image runs the application with built assets

#### Watch Mode
Docker Compose watch now:
- Syncs Perl changes (`lib/`, `script/`)
- Rebuilds on frontend changes (`frontend/`)

### 6. Asset Handling

**Before:** Static CSS served directly
**After:**
- Built and minified CSS/JS bundles
- Content-based hashing for cache busting
- Source maps for debugging
- Tree-shaking and code splitting
- Assets served from `/dist/` path

### 7. Routing

**Before:** Client-side conditional rendering with `v-if`
**After:** Vue Router with proper SPA routing
- Routes: `/` (Home), `/about` (About)
- Client-side navigation
- Browser history integration

## How to Test

### 1. In DevContainer
```bash
# Frontend will be built automatically by postcreate.sh
docker compose up --build --watch
```

### 2. Local Development
```bash
# Build everything
./build.sh

# Start backend
morbo ./script/hello-perld

# (Optional) Start frontend dev server in another terminal
cd frontend && npm run dev
```

### 3. Docker Production
```bash
docker compose up --build
```

## Troubleshooting

### Issue: Assets not loading
**Solution:** Ensure frontend is built:
```bash
cd frontend && npm run build
```

### Issue: Vite dev server not proxying API calls
**Solution:** Check `vite.config.js` proxy configuration and ensure backend is running on port 3000

### Issue: Docker build fails
**Solution:** Check that `package.json` and `package-lock.json` exist in `frontend/` directory

### Issue: CSS styles not applied
**Solution:** Rebuild frontend and clear browser cache

## Benefits of This Approach

1. **Performance:** Bundled, minified, and tree-shaken assets
2. **Developer Experience:** Hot Module Replacement, component dev tools
3. **Maintainability:** Component-based architecture, proper file organization
4. **Scalability:** Easy to add new pages, components, and features
5. **Modern Tooling:** Vue 3 Composition API, Vite build system
6. **Type Safety Ready:** Easy to add TypeScript if needed
7. **Better Caching:** Content-hashed filenames for optimal caching

## Next Steps

Consider adding:
- TypeScript for type safety
- ESLint/Prettier for code formatting
- Vitest for component testing
- Pinia for state management
- CSS preprocessor (SCSS/PostCSS)
- Environment-based configuration
- API client layer with proper error handling
