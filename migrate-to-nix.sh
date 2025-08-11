#!/usr/bin/env bash
#
# Migration script from pre-Nix dotfiles to Nix-based configuration
# This script helps migrate from the old Homebrew/symlink-based setup to the new Nix setup
#

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running on macOS
if [[ $(uname) != "Darwin" ]]; then
    log_error "This migration script is designed for macOS only"
    exit 1
fi

echo "========================================"
echo "Dotfiles Migration to Nix"
echo "========================================"
echo ""

# Step 1: Create backup directory
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
log_info "Creating backup directory: $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"

# Step 2: Backup existing configurations
log_info "Backing up existing configurations..."

# Backup symlinked files
SYMLINKS_TO_BACKUP=(
    "$HOME/.config/aerospace/aerospace.toml"
    "$HOME/.config/alacritty/alacritty.yml"
    "$HOME/.editorconfig"
    "$HOME/.config/ghostty/config"
    "$HOME/.gitconfig.personal"
    "$HOME/.config/kanshi/config"
    "$HOME/.config/starship.toml"
    "$HOME/.config/sway/config"
    "$HOME/.vimrc"
    "$HOME/.config/waybar/config"
    "$HOME/.config/waybar/style.css"
    "$HOME/.config/wofi/config"
    "$HOME/.config/wofi/style.css"
    "$HOME/wallpaper.jpeg"
)

for symlink in "${SYMLINKS_TO_BACKUP[@]}"; do
    if [[ -e "$symlink" || -L "$symlink" ]]; then
        target_dir="$BACKUP_DIR/$(dirname "${symlink#$HOME/}")"
        mkdir -p "$target_dir"
        cp -LR "$symlink" "$target_dir/" 2>/dev/null || true
        log_success "Backed up: $symlink"
    fi
done

# Backup Fish configuration
if [[ -d "$HOME/.config/fish" ]]; then
    log_info "Backing up Fish configuration..."
    cp -R "$HOME/.config/fish" "$BACKUP_DIR/.config/"
    log_success "Fish configuration backed up"
fi

# Backup Homebrew Brewfile
if [[ -f "$HOME/.Brewfile" ]] || [[ -f "$(pwd)/brew/Brewfile" ]]; then
    log_info "Backing up Brewfile..."
    mkdir -p "$BACKUP_DIR/brew"
    [[ -f "$HOME/.Brewfile" ]] && cp "$HOME/.Brewfile" "$BACKUP_DIR/brew/"
    [[ -f "$(pwd)/brew/Brewfile" ]] && cp "$(pwd)/brew/Brewfile" "$BACKUP_DIR/brew/"
    log_success "Brewfile backed up"
fi

# Step 3: Extract installed packages
log_info "Extracting list of installed packages..."

# Extract Homebrew packages
if command -v brew &> /dev/null; then
    log_info "Listing Homebrew packages..."
    brew list --formula > "$BACKUP_DIR/brew-packages.txt"
    brew list --cask > "$BACKUP_DIR/brew-casks.txt"
    log_success "Homebrew packages listed"
fi

# Extract Fisher plugins
if command -v fisher &> /dev/null; then
    log_info "Listing Fisher plugins..."
    fisher list > "$BACKUP_DIR/fisher-plugins.txt" 2>/dev/null || true
    log_success "Fisher plugins listed"
fi

# Step 4: Remove old symlinks
log_info "Removing old symlinks..."
for symlink in "${SYMLINKS_TO_BACKUP[@]}"; do
    if [[ -L "$symlink" ]]; then
        rm "$symlink"
        log_success "Removed symlink: $symlink"
    fi
done

# Step 5: Provide migration instructions
cat << EOF

${GREEN}Backup completed!${NC} Your old configuration has been saved to:
${BLUE}$BACKUP_DIR${NC}

${YELLOW}Next Steps:${NC}

1. ${BLUE}Install Nix${NC} (if not already installed):
   ${GREEN}curl -L https://nixos.org/nix/install | sh${NC}

2. ${BLUE}Clone the new Nix-based dotfiles${NC}:
   ${GREEN}git clone https://github.com/srizzling/.dotfiles.fish ~/.dotfiles${NC}
   ${GREEN}cd ~/.dotfiles${NC}

3. ${BLUE}Bootstrap your system${NC}:
   For personal use:
   ${GREEN}make bootstrap-personal${NC}
   
   For work use:
   ${GREEN}make bootstrap-work${NC}

4. ${BLUE}Review package mappings${NC}:
   The following files contain your old packages:
   - Homebrew formulae: ${BLUE}$BACKUP_DIR/brew-packages.txt${NC}
   - Homebrew casks: ${BLUE}$BACKUP_DIR/brew-casks.txt${NC}
   - Fisher plugins: ${BLUE}$BACKUP_DIR/fisher-plugins.txt${NC}

   Most packages have been migrated to Nix equivalents in the new setup.
   Check ${BLUE}home-manager/packages.nix${NC} to ensure all your tools are included.

5. ${BLUE}Migrate custom configurations${NC}:
   Review your backed-up configurations and migrate any customizations:
   - Fish functions: ${BLUE}$BACKUP_DIR/.config/fish/functions/${NC}
   - Git config: ${BLUE}$BACKUP_DIR/.gitconfig.personal${NC}
   - Custom aliases: ${BLUE}$BACKUP_DIR/.config/fish/conf.d/${NC}

${YELLOW}Important Notes:${NC}
- The new setup uses Nix for package management instead of Homebrew
- Fish plugins are now managed via Home Manager instead of Fisher
- All configurations are declarative and stored in the dotfiles repo
- Some GUI apps still use Homebrew via brew-nix integration

${RED}After verification:${NC}
Once you've confirmed the new setup works correctly, you can:
1. Remove the backup: ${GREEN}rm -rf $BACKUP_DIR${NC}
2. Uninstall Homebrew (optional): ${GREEN}/bin/bash -c "\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"${NC}

EOF

# Create a migration report
cat > "$BACKUP_DIR/migration-report.md" << EOF
# Dotfiles Migration Report
Generated: $(date)

## Backed Up Configurations
$(find "$BACKUP_DIR" -type f -not -name "migration-report.md" | sed "s|$BACKUP_DIR|- |g")

## Package Mappings

### Homebrew → Nix Package Equivalents
Common mappings (review home-manager/packages.nix for full list):
- bat → bat
- eza → eza (lsd in new config)
- fzf → fzf
- gh → gh
- git → git
- jq → jq
- ripgrep → ripgrep
- starship → starship (via programs.starship)
- tmux → tmux

### Fish Plugins → Home Manager
Fisher plugins are now in home-manager/shell.nix:
- jorgebucaran/fisher → (removed, using Home Manager)
- franciscolourenco/done → (consider home-manager equivalent)
- meaningful-ooo/sponge → (consider home-manager equivalent)
- jorgebucaran/autopair.fish → (review if needed)

### GUI Applications
Still managed via Homebrew (brew-nix):
- Ghostty
- VSCode
- Other casks

## Custom Configurations to Review
1. Fish aliases and functions
2. Git configuration  
3. SSH configuration
4. Any custom scripts

## Post-Migration Checklist
- [ ] Verify all essential packages are installed
- [ ] Test Fish shell and plugins
- [ ] Verify Git configuration
- [ ] Test GUI applications
- [ ] Review and migrate custom functions
EOF

log_success "Migration report created: $BACKUP_DIR/migration-report.md"