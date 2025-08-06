#!/bin/bash
echo "=== MANUAL DEPLOYMENT INSTRUCTIONS ==="
echo "Since this is the first nix-darwin deployment, you need to run:"
echo ""
echo "sudo /nix/store/sspxgd7pkl0zibjhyfkz42agy72fali8-darwin-rebuild/bin/darwin-rebuild switch --flake .#personal"
echo ""
echo "After this initial setup, you can use: darwin-rebuild switch --flake .#personal"
echo "This requires manual execution due to sudo password prompt."