#!/usr/bin/env fish
# Fishtape tests for Nix packages

# Core Utilities Tests
@test "bat is available and working" (bat --version | string match -q "bat*")
@test "curl is available and working" (curl --version | string match -q "curl*")
@test "fd is available and working" (fd --version | string match -q "fd*")  
@test "fzf is available and working" (fzf --version | string match -q "*.*")
@test "direnv is available and working" (direnv --version | string match -q "*.*")

# Git Tools Tests
@test "git is available and working" (git --version | string match -q "git version*")
@test "git-absorb is available and working" (git-absorb --version | string match -q "git-absorb*")
@test "delta is available and working" (delta --version | string match -q "delta*")
@test "GitHub CLI is available and working" (gh --version | string match -q "gh version*")

# Shell Tools Tests
@test "lsd is available and working" (lsd --version | string match -q "lsd*")
@test "starship is available and working" (starship --version | string match -q "starship*")
@test "zoxide is available and working" (zoxide --version | string match -q "zoxide*")
@test "grc is available and working" (grc --version | string match -q "Generic Colouriser*")
@test "gum is available and working" (gum --version | string match -q "gum*")

# Development Tools Tests  
@test "wget is available and working" (wget --version | string match -q "GNU Wget*")
@test "python3 is available and working" (python --version | string match -q "Python 3*")
@test "jq is available and working" (jq --version | string match -q "jq-*")
@test "ripgrep is available and working" (rg --version | string match -q "ripgrep*")
@test "tree is available and working" (tree --version | string match -q "tree v*")
@test "htop is available and working" (htop --version | string match -q "htop*")  
@test "just is available and working" (just --version | string match -q "just*")
@test "devbox is available and working" (devbox version | string match -q "*.*")

# Container Tools Tests
@test "podman is available and working" (podman --version | string match -q "podman version*")
@test "podman-compose is available and working" (podman-compose --version | string match -q "*.*")

# Fish Configuration Tests
@test "PATH includes Nix system binaries" (echo $PATH | string match -q "*/run/current-system/sw/bin*")
@test "PATH includes per-user profile" (echo $PATH | string match -q "*/etc/profiles/per-user/*")
@test "docker alias points to podman" (fish -c "which docker" | string match -q "*podman*")

# Fish Testing Tools
@test "fishtape is available and working" (fishtape --version | string match -q "fishtape version*")

# New Packages Tests  
@test "claude is available and working" (claude --version | string match -q "*Claude Code*")
@test "firefox app is installed" (test -d "/Applications/Nix Apps/Firefox.app" -o -d "/Applications/Firefox.app")
@test "cocogitto is available and working" (cog --version | string match -q "cog*")
@test "chdman is available and working" (chdman | string match -q "*MAME Compressed Hunks of Data*")