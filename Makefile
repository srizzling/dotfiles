# Nix Dotfiles Makefile (macOS + Linux)
# Usage: make bootstrap-personal (or bootstrap-work, bootstrap-linux)

# Configuration names
PERSONAL_CONFIG = personal
WORK_CONFIG = work
LINUX_CONFIG = srizzling@BlueShell

test-flake: ## Check Nix flake evaluation
	@echo "🔍 Checking Nix flake..."
	nix flake check --no-build

# Default target
.PHONY: help
help:
	@echo "Nix Darwin Dotfiles Management (Apple Silicon)"
	@echo ""
	@echo "Bootstrap commands:"
	@echo "  make bootstrap-personal       - Setup personal configuration"
	@echo "  make bootstrap-work           - Setup work configuration"
	@echo ""
	@echo "Management commands:"
	@echo "  make switch                   - Apply current configuration"
	@echo "  make update                   - Update flake inputs and apply"
	@echo "  make rollback                 - Rollback to previous generation"
	@echo "  make clean                    - Clean old generations (keep last 5)"
	@echo "  make rebuild                  - Rebuild without switching"
	@echo ""
	@echo "Testing commands:"
	@echo "  make test                     - Run all Fishtape tests"
	@echo "  make test-packages            - Run package availability tests"
	@echo "  make test-fish-config         - Run Fish configuration tests"
	@echo ""
	@echo "Release commands:"
	@echo "  make release                  - Create new release based on conventional commits"
	@echo ""
	@echo "Linux commands:"
	@echo "  make bootstrap-linux          - Bootstrap Linux (CachyOS) configuration"
	@echo "  make switch-linux             - Apply Linux home-manager configuration"
	@echo "  make install-pacman-deps      - Install required pacman/AUR packages"
	@echo ""
	@echo "Installation commands:"
	@echo "  make install-nix              - Install Nix with flakes support"
	@echo "  make install-darwin           - Install nix-darwin"

# Check if Nix is installed
.PHONY: check-nix
check-nix:
	@command -v nix >/dev/null 2>&1 || { echo "Nix not found. Run 'make install-nix' first."; exit 1; }

# Install Nix with flakes support
.PHONY: install-nix
install-nix:
	@echo "Installing Nix with flakes support..."
	@curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
	@echo "Nix installed! Please restart your shell and run the bootstrap command again."

# Install nix-darwin
.PHONY: install-darwin
install-darwin: check-nix
	@echo "Installing nix-darwin..."
	@nix run nix-darwin -- switch --flake .
	@echo "nix-darwin installed!"

# Bootstrap commands
.PHONY: bootstrap-personal
bootstrap-personal:
	@echo "Bootstrapping personal configuration..."
	@$(MAKE) _bootstrap CONFIG=$(PERSONAL_CONFIG)

.PHONY: bootstrap-work
bootstrap-work:
	@echo "Bootstrapping work configuration..."
	@$(MAKE) _bootstrap CONFIG=$(WORK_CONFIG)

# Internal bootstrap implementation
.PHONY: _bootstrap
_bootstrap: check-nix
	@echo "Setting up $(CONFIG) configuration..."
	@# Install nix-darwin if not already installed
	@if ! command -v darwin-rebuild >/dev/null 2>&1; then \
		echo "Installing nix-darwin..."; \
		nix run nix-darwin -- switch --flake .#$(CONFIG); \
	else \
		echo "Applying $(CONFIG) configuration..."; \
		darwin-rebuild switch --flake .#$(CONFIG); \
	fi
	@echo "Bootstrap complete! Configuration $(CONFIG) is now active."
	@echo "You may need to restart your terminal for all changes to take effect."

# Apply current configuration (requires darwin-rebuild to be available)
.PHONY: switch
switch:
	@echo "Applying current configuration..."
	@sudo -E /run/current-system/sw/bin/darwin-rebuild switch --flake path:.#personal

# Update flake inputs and apply
.PHONY: update
update:
	@echo "Updating flake inputs..."
	@nix flake update
	@echo "Applying updated configuration..."
	@sudo -E /run/current-system/sw/bin/darwin-rebuild switch --flake path:.#personal

# Rollback to previous generation
.PHONY: rollback
rollback:
	@echo "Rolling back to previous generation..."
	@sudo -E /run/current-system/sw/bin/darwin-rebuild rollback

# Rebuild without switching
.PHONY: rebuild
rebuild:
	@echo "Building configuration..."
	@sudo -E /run/current-system/sw/bin/darwin-rebuild build --flake path:.#personal

# Clean old generations (keep last 5)
.PHONY: clean
clean:
	@echo "Cleaning old generations (keeping last 5)..."
	@sudo nix-collect-garbage --delete-older-than 30d
	@nix-collect-garbage --delete-older-than 30d

# Show current generation and available rollback options
.PHONY: generations
generations:
	@echo "Current generation and rollback options:"
	@sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# Show flake info
.PHONY: info
info:
	@echo "Flake information:"
	@nix flake show

# Validate configuration without building
.PHONY: check
check:
	@echo "Checking flake configuration..."
	@nix flake check

# Testing commands (integrated from test/Makefile)
.PHONY: test test-packages test-fish-config
test: ## Run all Fishtape tests (recommended)
	@echo "🐟 Running Fishtape tests..."
	@cd test && fish -i -c "fishtape packages.test.fish fish-config.test.fish; exit"

test-packages: ## Run package availability tests
	@echo "🏠 Testing Nix packages with Fishtape..."
	@cd test && fish -i -c "fishtape packages.test.fish; exit"

test-fish-config: ## Run Fish configuration tests
	@echo "🐚 Testing Fish shell configuration..."
	@cd test && fish -i -c "fishtape fish-config.test.fish; exit"

# Release commands
.PHONY: release
release: ## Create new release based on conventional commits
	@echo "🚀 Creating new release based on conventional commits..."
	@command -v cog >/dev/null 2>&1 || { echo "❌ Cocogitto (cog) not found. Run 'make switch' to install it."; exit 1; }
	@echo "📝 Analyzing conventional commits since last tag..."
	@cog bump --auto
	@echo "🏷️ Pushing tag to remote to trigger GitHub release..."
	@git push origin $$(git describe --tags --abbrev=0)
	@echo "✅ Release created and pushed! GitHub workflow will create the release automatically."

# ── Linux (CachyOS/Hyprland) targets ──

# Bootstrap Linux configuration (first-time setup)
.PHONY: bootstrap-linux
bootstrap-linux: check-nix
	@echo "Bootstrapping Linux (CachyOS) configuration..."
	@$(MAKE) install-pacman-deps
	@nix run home-manager -- switch -b backup --flake .#$(LINUX_CONFIG)
	@echo "Bootstrap complete! You may need to restart Hyprland for all changes to take effect."

# Apply Linux home-manager configuration
.PHONY: switch-linux
switch-linux: check-nix
	@echo "Applying Linux home-manager configuration..."
	@home-manager switch -b backup --flake .#$(LINUX_CONFIG)

# Install required pacman/AUR packages for the Linux setup
.PHONY: install-pacman-deps
install-pacman-deps:
	@echo "Installing system packages via pacman..."
	sudo pacman -S --needed ghostty ghostty-shell-integration hyprlock hypridle playerctl fuzzel awww yad dms-shell-hyprland matugen
	@echo "Installing GUI apps via pacman..."
	sudo pacman -S --needed vesktop freetube spotify-launcher
	@echo "Installing AUR packages via paru..."
	paru -S --needed zapzap
	@echo "All system packages installed."

# Setup Spotify Rose Pine theme via spicetify
.PHONY: setup-spotify-theme
setup-spotify-theme:
	@echo "Setting up Spotify Rose Pine theme..."
	@spicetify config current_theme catppuccin
	@spicetify config color_scheme macchiato
	@spicetify config inject_css 1 replace_colors 1
	@spicetify backup apply
	@echo "Spotify theme applied! Restart Spotify to see changes."

