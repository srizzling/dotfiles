#!/bin/bash
set -e

echo "=== DEPLOYING NIX-DARWIN CONFIGURATION ==="

# Check if we need to bootstrap nix-darwin
if ! command -v darwin-rebuild &> /dev/null; then
    echo "First time setup - bootstrapping nix-darwin..."
    echo "This will require sudo access to modify system files."
    echo "Please run: sudo $(nix run nix-darwin -- switch --flake .#personal 2>&1 | grep darwin-rebuild | cut -d' ' -f1) switch --flake .#personal"
    exit 1
fi

# If darwin-rebuild exists, use it normally
echo "Using existing darwin-rebuild..."
darwin-rebuild switch --flake .#personal