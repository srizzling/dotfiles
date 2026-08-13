# Nix Dotfiles

Modern, declarative configuration for macOS and Linux using Nix, with Fish shell, comprehensive package management, and Catppuccin theming throughout.

| Platform | Managed by | Configuration |
|---|---|---|
| macOS (Apple Silicon) | nix-darwin + Home Manager | `darwinConfigurations.personal` / `.work` |
| Linux (CachyOS + Hyprland) | standalone Home Manager | `homeConfigurations."srizzling@BlueShell"` |

Shell, git, theming, and the common package set are shared. Window management diverges by platform: AeroSpace on macOS, Hyprland with Waybar on Linux.

## Quick Start

```bash
# Install Nix
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# Clone and setup
git clone https://github.com/srizzling/dotfiles.git ~/.dotfiles && cd ~/.dotfiles
```

### macOS
```bash
make bootstrap-personal    # or make bootstrap-work
```

### Linux
Home Manager owns the user environment; system packages come from pacman, which `bootstrap-linux` installs for you.

```bash
make bootstrap-linux
```

### Daily Commands
```bash
make switch        # Apply configuration changes (macOS)
make switch-linux  # Apply configuration changes (Linux)
make update        # Update flake inputs and apply (macOS)
make rollback      # Rollback to previous generation (macOS)
make test          # Run all tests
make release       # Create new release
```

## Tools Included

### Development
- **Languages**: Python, Node.js, Go, Rust toolchains via devbox
- **CLI Tools**: git, gh, ripgrep, fd, fzf, jq, curl, wget, just
- **Development**: docker (via OrbStack), devbox, claude-code

### Terminal
- **Shell**: Fish with plugins, autosuggestions, git-emoji functions  
- **Terminal**: Ghostty (GPU-accelerated)
- **Prompt**: Starship with Git integration
- **Theme**: Catppuccin Macchiato everywhere
- **Tools**: bat, lsd, htop, tree, zoxide, direnv

### Applications  
- **Browser**: Firefox
- **Productivity**: Raycast (Spotlight replacement, macOS)

### Desktop
- **macOS**: AeroSpace tiling window manager
- **Linux**: Hyprland with Waybar, dunst, and fuzzel

### System
- **Package Manager**: Nix (50+ tools), plus brew-nix for macOS GUI apps and pacman for Linux system packages
- **Configuration**: Declarative Nix files + Home Manager
- **Testing**: Comprehensive Fishtape test suite (51 tests)

## Architecture

- **Nix Darwin**: System-level macOS configuration (Apple Silicon)
- **Home Manager**: User-level packages and dotfiles on both platforms — standalone on Linux, as a nix-darwin module on macOS
- **Flakes**: Pin dependencies for reproducible builds
- **Multi-profile**: `personal` and `work` on macOS; `srizzling@BlueShell` on Linux
- **Shared modules**: `packages-common.nix` and the shell/git/theme modules apply everywhere; `packages-darwin.nix` and `packages-linux.nix` hold the platform-specific sets
- **Testing**: All packages tested with Fish-based test runners

## Releasing

Versions are derived from conventional commits; GitHub Actions publishes the release when the tag lands.

```bash
make release-notes   # Review what changed since the last tag
                     # Rewrite RELEASE_NOTES.md to describe it, then commit
make release         # Bump version, push the commit and the tag
```

A published release is `RELEASE_NOTES.md` followed by the auto-generated commit changelog grouped by scope — the written summary explains what the changes mean, the changelog records exactly what landed.

`make release` refuses to run when `RELEASE_NOTES.md` hasn't changed since the last tag, so a release can't silently inherit the previous one's summary. Override with `make release SKIP_NOTES_CHECK=1` to publish with the changelog alone.

## Development

See [CLAUDE.md](./CLAUDE.md) for git-emoji commit conventions, release workflows, and development guidelines.