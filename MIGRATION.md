# Migration Guide: Pre-Nix to Nix-based Dotfiles

This guide helps you migrate from the old Homebrew/symlink-based dotfiles to the new Nix-based configuration.

## Overview

The new dotfiles setup uses:
- **Nix Darwin** for system-level macOS configuration
- **Home Manager** for user packages and dotfiles
- **Nix Flakes** for reproducible, declarative configuration
- **brew-nix** for GUI applications that aren't available in nixpkgs

## Pre-Migration Checklist

1. **Backup your current configuration** (the migration script does this automatically)
2. **Note any custom Fish functions or aliases**
3. **Export your Homebrew package list**
4. **Save any custom configurations** (git, vim, etc.)

## Migration Steps

### 1. Analyze Your Current System

Run the analysis script to understand your current setup:

```bash
./analyze-migration.fish
```

This will show:
- Installed package managers
- Current shell configuration  
- Existing dotfiles
- Potential conflicts

### 2. Run the Migration Script

Execute the migration script to backup your configuration:

```bash
./migrate-to-nix.sh
```

This will:
- Create a timestamped backup of all configurations
- Remove old symlinks
- Generate a migration report
- Provide next steps

### 3. Install Nix (if needed)

If you don't have Nix installed:

```bash
# Official Nix installer
curl -L https://nixos.org/nix/install | sh
```

### 4. Clone and Bootstrap

Clone the new dotfiles and bootstrap your system:

```bash
# Clone the repository
git clone https://github.com/srizzling/.dotfiles.fish ~/.dotfiles
cd ~/.dotfiles

# For personal machines
make bootstrap-personal

# For work machines  
make bootstrap-work
```

### 5. Post-Migration Tasks

#### Fish Shell Configuration

The new setup manages Fish differently:

**Old way (Fisher):**
```fish
fisher install jorgebucaran/autopair.fish
fisher install franciscolourenco/done
```

**New way (Home Manager):**
All plugins are declared in `home-manager/shell.nix`:
```nix
programs.fish = {
  plugins = [
    {
      name = "autopair";
      src = pkgs.fetchFromGitHub { ... };
    }
  ];
};
```

#### Custom Functions and Aliases

1. Check your backup for custom functions:
   ```bash
   ls ~/.dotfiles-backup-*/config/fish/functions/
   ```

2. Add them to the new configuration:
   - Simple aliases: Add to `shellAliases` in `home-manager/shell.nix`
   - Complex functions: Add to `functions` in `home-manager/shell.nix`

Example:
```nix
programs.fish = {
  shellAliases = {
    ll = "lsd -la";
    gs = "git status";
  };
  
  functions = {
    gitclean = ''
      git branch --merged | grep -v main | xargs -n 1 git branch -d
    '';
  };
};
```

#### Package Migration

Most command-line tools have direct Nix equivalents:

| Homebrew | Nix Package | Location |
|----------|-------------|----------|
| bat | bat | home-manager/packages.nix |
| eza/exa | lsd | home-manager/packages.nix |
| fzf | fzf | home-manager/packages.nix |
| ripgrep | ripgrep | home-manager/packages.nix |
| starship | programs.starship | home-manager/shell.nix |
| gh | gh | home-manager/packages.nix |

GUI applications remain in Homebrew (via brew-nix):
- Ghostty
- Visual Studio Code
- Other macOS apps

## Common Issues and Solutions

### Issue: Conflicting Nix Installation

If you have an existing Nix installation that conflicts:

```bash
# Backup existing Nix configuration
sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.backup

# Restart Nix daemon
sudo launchctl stop org.nixos.nix-daemon
sudo launchctl start org.nixos.nix-daemon
```

### Issue: Fish Plugins Not Working

Plugins are now managed by Home Manager. To add a missing plugin:

1. Find the plugin's GitHub repository
2. Get the commit hash: `git ls-remote https://github.com/OWNER/REPO HEAD`
3. Get the SHA256: `nix-prefetch-github OWNER REPO --rev COMMIT`
4. Add to `home-manager/shell.nix`

### Issue: Missing Packages

To add packages not in the default configuration:

1. Search nixpkgs: `nix search nixpkgs PACKAGE_NAME`
2. Add to `home-manager/packages.nix`
3. Run `make switch`

### Issue: Homebrew Conflicts

The new setup uses Homebrew only for GUI apps. If you have conflicts:

1. List non-GUI formulae: `brew list --formula`
2. Uninstall CLI tools available in Nix: `brew uninstall PACKAGE`
3. Keep only casks and formulae not in nixpkgs

## Verification

After migration, verify everything works:

```bash
# Run the test suite
make test

# Check Fish configuration
fish -c "echo 'Fish is working'"

# Verify Git configuration  
git config --list

# Test common tools
bat --version
lsd --version
fzf --version
```

## Rollback

If you need to rollback:

1. **Restore from backup:**
   ```bash
   cp -R ~/.dotfiles-backup-*/.config ~/
   ```

2. **Remove Nix dotfiles:**
   ```bash
   rm -rf ~/.dotfiles
   ```

3. **Reinstall old tools:**
   ```bash
   brew bundle --file=~/.dotfiles-backup-*/brew/Brewfile
   ```

## Benefits of the New System

1. **Reproducible**: Same configuration on any Mac
2. **Declarative**: All configuration in code
3. **Atomic updates**: Updates succeed or fail as a unit
4. **Rollback capability**: Easy to revert changes
5. **Better performance**: Nix packages are optimized
6. **Cleaner system**: No more symlink management

## Getting Help

- Check existing issues in the repository
- Review `CLAUDE.md` for development guidelines
- Run `make help` for available commands
- Use `nix flake check` to validate configuration