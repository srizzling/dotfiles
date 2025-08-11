#!/usr/bin/env fish
#
# Fish script to analyze current system and provide migration recommendations
#

set -l RED (set_color red)
set -l GREEN (set_color green)
set -l YELLOW (set_color yellow)
set -l BLUE (set_color blue)
set -l NORMAL (set_color normal)

function log_section
    echo ""
    echo "$BLUE=== $argv ===$NORMAL"
    echo ""
end

function check_mark
    echo "$GREEN✓$NORMAL"
end

function cross_mark
    echo "$RED✗$NORMAL"
end

function warning_mark
    echo "$YELLOW⚠$NORMAL"
end

echo "========================================="
echo "   Dotfiles Migration Analysis Tool"
echo "========================================="

# Check current environment
log_section "System Information"
echo "OS: "(uname -s)" "(uname -r)
echo "Architecture: "(uname -m)
echo "Hostname: "(hostname)

# Check for existing package managers
log_section "Package Managers"

# Check Homebrew
if command -v brew &>/dev/null
    echo (check_mark)" Homebrew installed: "(brew --version | head -1)
    set -l formula_count (brew list --formula 2>/dev/null | wc -l | string trim)
    set -l cask_count (brew list --cask 2>/dev/null | wc -l | string trim)
    echo "  - Formulae installed: $formula_count"
    echo "  - Casks installed: $cask_count"
else
    echo (cross_mark)" Homebrew not installed"
end

# Check Nix
if command -v nix &>/dev/null
    echo (check_mark)" Nix installed: "(nix --version)
    if test -f /etc/nix/nix.conf
        echo "  - Multi-user installation detected"
    else
        echo "  - Single-user installation detected"
    end
else
    echo (cross_mark)" Nix not installed"
end

# Check current shell
log_section "Shell Configuration"
echo "Current shell: $SHELL"
echo "Fish version: "(fish --version)

# Check for Fish plugins
if command -v fisher &>/dev/null
    echo (check_mark)" Fisher installed"
    set -l plugin_count (fisher list 2>/dev/null | wc -l | string trim)
    echo "  - Plugins installed: $plugin_count"
    if test $plugin_count -gt 0
        echo "  - Installed plugins:"
        fisher list 2>/dev/null | sed 's/^/    - /'
    end
else
    echo (cross_mark)" Fisher not installed"
end

# Check for existing dotfiles
log_section "Existing Dotfiles"

set -l dotfiles_to_check \
    "$HOME/.config/fish/config.fish" \
    "$HOME/.config/starship.toml" \
    "$HOME/.gitconfig" \
    "$HOME/.config/ghostty/config" \
    "$HOME/.config/aerospace/aerospace.toml" \
    "$HOME/.vimrc" \
    "$HOME/.config/alacritty/alacritty.yml"

for file in $dotfiles_to_check
    if test -e $file
        if test -L $file
            echo (check_mark)" $file (symlink → "(readlink $file)")"
        else
            echo (check_mark)" $file (regular file)"
        end
    else
        echo (cross_mark)" $file (not found)"
    end
end

# Analyze potential conflicts
log_section "Migration Readiness"

set -l issues 0

# Check if already using Nix dotfiles
if test -d "$HOME/.dotfiles" -a -f "$HOME/.dotfiles/flake.nix"
    echo (warning_mark)" Existing Nix dotfiles found at ~/.dotfiles"
    set issues (math $issues + 1)
end

# Check for nix-darwin
if test -f /run/current-system/sw/bin/darwin-rebuild
    echo (warning_mark)" nix-darwin already installed"
    echo "  - Current generation: "(darwin-rebuild --list-generations | tail -1)
    set issues (math $issues + 1)
end

# Check for home-manager
if command -v home-manager &>/dev/null
    echo (warning_mark)" home-manager already installed"
    set issues (math $issues + 1)
end

if test $issues -eq 0
    echo (check_mark)" No conflicts detected - ready for migration"
else
    echo ""
    echo "$YELLOW$issues potential conflicts detected$NORMAL"
    echo "You may need to backup or remove existing Nix configurations"
end

# Generate package mapping recommendations
log_section "Package Migration Recommendations"

if command -v brew &>/dev/null
    echo "Analyzing installed Homebrew packages..."
    echo ""
    
    # Common package mappings
    set -l brew_to_nix \
        "bat:bat" \
        "eza:eza or lsd" \
        "exa:eza or lsd" \
        "fzf:fzf" \
        "gh:gh" \
        "git:git" \
        "jq:jq" \
        "ripgrep:ripgrep" \
        "fd:fd" \
        "tmux:tmux" \
        "neovim:neovim" \
        "vim:vim" \
        "htop:htop" \
        "tree:tree" \
        "wget:wget" \
        "curl:curl" \
        "starship:programs.starship"
    
    set -l found_mappings 0
    for mapping in $brew_to_nix
        set -l brew_pkg (string split ":" $mapping)[1]
        set -l nix_pkg (string split ":" $mapping)[2]
        
        if brew list --formula | grep -q "^$brew_pkg\$"
            echo "  • $brew_pkg → $nix_pkg"
            set found_mappings (math $found_mappings + 1)
        end
    end
    
    if test $found_mappings -gt 0
        echo ""
        echo "$GREEN$found_mappings packages have direct Nix equivalents$NORMAL"
    end
    
    # Check for GUI apps
    set -l gui_apps (brew list --cask 2>/dev/null)
    if test (count $gui_apps) -gt 0
        echo ""
        echo "GUI applications (will remain in Homebrew via brew-nix):"
        for app in $gui_apps
            echo "  • $app"
        end
    end
end

# Final recommendations
log_section "Next Steps"

echo "1. Run the migration script to backup your current configuration:"
echo "   $GREEN./migrate-to-nix.sh$NORMAL"
echo ""
echo "2. Review the generated backup and migration report"
echo ""
echo "3. Follow the bootstrap process for the new Nix-based dotfiles"
echo ""

if test $issues -gt 0
    echo "$YELLOW""Note: You have existing Nix configurations that may need attention$NORMAL"
    echo "Consider backing up or removing them before proceeding"
end