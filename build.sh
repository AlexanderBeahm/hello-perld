#!/bin/bash
set -e
set -u

echo "Building HelloPerld..."
echo ""

# Check for required commands
if ! command -v node &> /dev/null; then
    echo "❌ Error: Node.js is not installed. Please install Node.js before running this script."
    exit 1
fi

if ! command -v npm &> /dev/null; then
    echo "❌ Error: npm is not installed. Please install npm before running this script."
    exit 1
fi

if ! command -v cpanm &> /dev/null; then
    echo "❌ Error: cpanm is not installed. Please install cpanminus before running this script."
    exit 1
fi

# Build frontend
echo "📦 Building frontend..."
if [ ! -d "frontend" ]; then
    echo "❌ Error: frontend directory not found"
    exit 1
fi

cd frontend
npm install || { echo "❌ Error: npm install failed"; exit 1; }
npm run build || { echo "❌ Error: frontend build failed"; exit 1; }
cd ..
echo "✓ Frontend built successfully"
echo ""

# Install Perl dependencies
echo "📦 Installing Perl dependencies..."
cpanm --installdeps --notest . || { echo "❌ Error: Perl dependency installation failed"; exit 1; }
echo "✓ Perl dependencies installed"
echo ""

echo "✓ Build complete! Run 'morbo ./script/hello-perld' to start the server."
