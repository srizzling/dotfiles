## Highlights

**Linux is documented as a supported platform.** CachyOS and Hyprland support landed in v4.11.0, but the README still described this as a macOS-only, Apple-Silicon-only repository — so the one place explaining how to set the thing up simply omitted an entire platform. It now covers both targets and how they differ: nix-darwin manages macOS, while Linux runs standalone Home Manager over CachyOS with system packages from pacman. The `darwin-rebuild`-backed commands (`switch`, `update`, `rollback`) are now marked as macOS-only rather than presented as universal.

**The pre-Nix migration tooling is gone.** Every machine now runs the Nix configuration, so the one-time helpers for escaping the old Homebrew/symlink setup had no remaining users — 859 lines of scripts and a migration guide that could only ever be run once, plus the README section pointing at them. `migrate-fish-config.fish` had already fallen out of the guide entirely and was referenced by nothing at all.

Anyone still needing them can retrieve them from tag `v4.12.0`.
