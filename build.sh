#!/bin/bash
set -e

echo "Building HelloPerld..."
echo ""

# Build frontend
echo "📦 Building frontend..."
cd frontend
npm install
npm run build
cd ..
echo "✓ Frontend built successfully"
echo ""

# Install Perl dependencies
echo "📦 Installing Perl dependencies..."
cpanm --installdeps --notest .
echo "✓ Perl dependencies installed"
echo ""

echo "✓ Build complete! Run 'morbo ./script/hello-perld' to start the server."
