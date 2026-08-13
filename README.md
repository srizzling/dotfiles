# Nix-based macOS Dotfiles

Modern, declarative macOS configuration using Nix Darwin + Home Manager with Fish shell, comprehensive package management, and beautiful Catppuccin theming.

## 🔄 Migrating from Pre-Nix Dotfiles

If you're migrating from the old Homebrew/symlink-based dotfiles:

1. **Run the migration analysis**:
   ```bash
   ./analyze-migration.fish
   ```

2. **Backup and migrate**:
   ```bash
   ./migrate-to-nix.sh
   ```

3. **Follow the migration guide**: See [MIGRATION.md](MIGRATION.md) for detailed instructions

## Quick Start

### Bootstrap
```bash
# Install Nix
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# Clone and setup
git clone https://github.com/srizzling/dotfiles.git ~/.dotfiles && cd ~/.dotfiles

# Bootstrap (auto-detects architecture)
make bootstrap-personal    # or make bootstrap-work
```

### Daily Commands
```bash
make switch      # Apply configuration changes
make update      # Update all packages  
make rollback    # Rollback to previous generation
make test        # Run all tests
make release     # Create new release
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
- **Productivity**: Raycast (Spotlight replacement)

### System
- **Package Manager**: Nix (50+ tools) + brew-nix (GUI apps)
- **Configuration**: Declarative Nix files + Home Manager
- **Testing**: Comprehensive Fishtape test suite (51 tests)
- **Architecture**: Apple Silicon only (personal/work profiles)

## Architecture

- **Nix Darwin**: System-level macOS configuration
- **Home Manager**: User-level package and dotfile management  
- **Flakes**: Pin dependencies for reproducible builds
- **Multi-profile**: `personal` and `work` configurations (Apple Silicon only)
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