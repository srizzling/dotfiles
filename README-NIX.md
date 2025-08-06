# Nix Dotfiles Configuration

This repository has been migrated from shell scripts + devbox to a fully declarative Nix configuration using nix-darwin and Home Manager.

## Phase 1: Foundation ✅

**What's migrated:**
- ✅ Nix flakes infrastructure
- ✅ macOS system settings (dock, scrolling, finder)
- ✅ Essential development packages (yamllint, shellcheck, gh, etc.)
- ✅ Fish shell with 5 essential plugins (down from 15)
- ✅ Host-specific git identity configuration
- ✅ Homebrew for GUI apps only

**Installation:**

1. Install Nix (if not already installed):
   ```bash
   curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
   ```

2. Install nix-darwin:
   ```bash
   nix run nix-darwin -- switch --flake .#personal
   # or for work machine:
   nix run nix-darwin -- switch --flake .#work
   ```

3. Future updates:
   ```bash
   darwin-rebuild switch --flake .#personal
   ```

**Testing Phase 1:**
```bash
nix build .#checks.aarch64-darwin.phase1-tests
```

## Fish Plugins (Reduced from 15 to 5)

| Plugin | Purpose | Status |
|--------|---------|--------|
| `jethrokuan/z` | Directory jumping | ✅ Kept |
| `jorgebucaran/autopair.fish` | Auto-pairing brackets | ✅ Kept |
| `patrickf1/fzf.fish` | Fuzzy finding | ✅ Kept |
| `srizzling/fish-git-emojis` | Git commit emojis | ✅ Kept |
| `catppuccin/fish` | Theme | ✅ Kept |
| `jorgebucaran/nvm.fish` | Node version manager | ❌ Removed (using devbox) |
| `halostatue/fish-direnv` | direnv integration | ❌ Removed (built-in) |
| `edc/bass` | Bash script runner | ❌ Removed (unused) |
| `srizzling/taxi-fish` | Custom plugin | ❌ Removed (as requested) |
| `grc` plugins | Command colorization | ❌ Removed (manage later) |

## Git Emoji Commands Available

From `srizzling/fish-git-emojis`:
- `gfeat` ✨ - New features
- `gfix` 🐛 - Bug fixes  
- `gdocs` 📝 - Documentation
- `gref` ♻️ - Refactoring
- `gbuild` 👷 - Build/chore
- `gtest` ✅ - Tests
- `gci` 💚 - CI changes
- `gperf` ⚡️ - Performance
- `gstyle` 🎨 - Code style

## macOS Settings Applied

- ✅ Dock auto-hide with smaller icons
- ✅ Natural scrolling disabled
- ✅ Show file extensions everywhere
- ✅ Faster key repeat
- ✅ No auto-correct/capitalize
- ✅ Tap to click
- ✅ Show path in Finder
- ✅ Screenshots to ~/Pictures/Screenshots

## Package Management

- **Nix**: CLI tools, development packages
- **Homebrew**: GUI applications only (aerospace, ghostty, teams, etc.)
- **npm**: claude-code (installed via Home Manager activation)
- **devbox**: Project-specific environments only

## Next Phases

- **Phase 2**: Shell configurations (starship, ghostty config)  
- **Phase 3**: Development environment (VSCode settings, vim)
- **Phase 4**: GUI integration & cleanup