# Development Guidelines

This file contains conventions and guidelines for contributing to this Nix-based dotfiles repository.

## Git Commit Conventions

This repository uses git-emoji conventions via Fish functions. The format is:

```bash
g<type> "<scope>" "<message>"
```

The functions automatically format commits as: `<type>(<scope>): <emoji> <message>`

### Available Functions

| Function | Type | Emoji | Description |
|----------|------|-------|-------------|
| `gfeat` | feat | ✨ | New features or functionality |
| `gfix` | fix | 🐛 | Bug fixes |
| `gdocs` | docs | 📝 | Documentation changes |
| `gstyle` | style | 🎨 | Code style changes (formatting, etc.) |
| `gref` | refactor | ♻️ | Code refactoring without functionality changes |
| `gtest` | test | ✅ | Adding or modifying tests |
| `gchore` | chore | 🧹 | Build process, tooling, or maintenance tasks |
| `gperf` | perf | ⚡ | Performance improvements |
| `gci` | ci | 👷 | Continuous integration changes |
| `gdepup` | chore | ⬆ | Dependency upgrades |
| `gdepdown` | chore | ⬇️ | Dependency downgrades |
| `gwip` | wip | 🚧 | Work in progress (auto-generates message) |

### Allowed Scopes

Use specific module names for targeted changes, broader categories for cross-cutting changes:

**Platform-specific:**
- `nix` - Nix language files, flake configuration
- `darwin` - macOS system-level configuration
- `homemanager` - Home Manager specific changes

**Module-specific:**
- `aerospace` - Window manager configuration
- `catppuccin` - Theme configuration
- `delta` - Git diff tool configuration
- `fzf` - Fuzzy finder integrations
- `ghostty` - Terminal emulator settings
- `git` - Git configuration
- `lsd` - Directory listing tool config
- `raycast` - Raycast launcher settings
- `shell` - Fish shell configuration

**Infrastructure:**
- `ci` - GitHub Actions, workflows
- `release` - Release configuration, changelogs
- `test` - Test files and configuration

### Example Commit Commands

```bash
gfeat "nix" "add Claude Code and Firefox packages"
gfix "shell" "resolve Fish completion generation issues"  
gdocs "readme" "update installation instructions"
gtest "ci" "add tests for GitHub Actions workflow"
gchore "ci" "remove temporary migration files"
gref "fzf" "consolidate fuzzy finder integrations"
gdepup "nix" "update nixpkgs to latest unstable"
```

### Actual Commit Format Generated

```
feat(nix): ✨ add Claude Code and Firefox packages
fix(fish): 🐛 resolve plugin hash mismatches
docs(readme): 📝 update installation instructions
test(packages): ✅ add tests for new GUI applications
chore(migration): 🧹 remove temporary migration files
refactor(shell): ♻️ consolidate Fish plugin configuration
```

## Package Management Guidelines

### Package Source Priority

1. **nixpkgs** (preferred) - Official Nix package repository
2. **brew-nix** (fallback) - When packages aren't available in nixpkgs
3. **fail** - Don't add packages that aren't available through either source

Before adding any package, always check nixpkgs availability:
```bash
nix search nixpkgs <package-name>
```

### Package Testing Requirements

All new packages must include comprehensive tests in the appropriate test file:

- System packages: `test/packages.test.fish`
- Fish configuration: `test/fish-config.test.fish`

Test format:
```fish
@test "<package> is available and working" (<command> --version | string match -q "<expected-output>")
```

## File Organization

### Core Configuration Files

- `flake.nix` - Main Nix flake configuration
- `darwin/` - macOS system-level configuration  
- `home-manager/` - User-level package and configuration management
- `test/` - Fishtape test suites

### Configuration Modules

- `home-manager/packages.nix` - User packages and CLI tools
- `home-manager/shell.nix` - Fish shell configuration and plugins
- `home-manager/default.nix` - Home Manager entry point and environment variables

## Testing

### Running Tests

```bash
make test          # Run all tests
make test-quick    # Run tests without slow container checks
```

### Test Categories

1. **Package Tests** - Verify installed packages work correctly
2. **Configuration Tests** - Verify Fish shell aliases, functions, and environment
3. **Integration Tests** - Verify complete system functionality

## Development Workflow

### Making Changes

1. Make your changes to the appropriate Nix files
2. Run tests to ensure everything works: `make test`
3. Build the configuration: `make switch`
4. Write tests for any new packages or functionality
5. Commit using git-emoji conventions

### Creating Releases

1. Ensure all changes are committed
2. Run `make release-notes` to see the commits since the last tag
3. Rewrite `RELEASE_NOTES.md` to describe those changes, and commit it
4. Run `make release` to bump the version and push the commit and tag
5. The GitHub workflow publishes the release automatically

#### Writing RELEASE_NOTES.md

This file becomes the top of the published release, directly above the
auto-generated commit changelog.

- **Write flowing prose, not bullet points.** The changelog below already lists
  every change; the summary exists to explain what they mean, which a list of
  fragments cannot do. Group related changes into paragraphs.
- Describe the change from the reader's side — what was broken or missing, and
  what is different now — rather than restating the commit subject.
- Scope it to the commits in this release. Check the tag boundary with
  `make release-notes`; do not rely on recent memory.

#### What bumps the version

`feat` bumps minor; `fix`, `docs` and `refactor` bump patch; breaking changes
bump major. Everything else (`chore`, `test`, `ci`, …) does not bump at all.
The `docs`/`refactor` behaviour is configured in `cog.toml` and is not cog's
default. If nothing in the range qualifies, `make release` fails rather than
reporting a release it did not make — use `make release BUMP=patch` to force one.

### Adding New Packages

1. Check if available in nixpkgs: `nix search nixpkgs <package>`
2. Add to appropriate packages list in `home-manager/packages.nix` or `flake.nix`
3. Write tests in `test/packages.test.fish`
4. Run `make test` to verify
5. Commit with appropriate git-emoji message

### Plugin Management

Fish plugins are managed declaratively in `home-manager/shell.nix`. When adding plugins:

1. Use `nix-prefetch-github` to get correct hash
2. Add minimal, essential plugins only
3. Remove redundant plugins (prefer home-manager modules when available)
4. Test plugin functionality

## Architecture Decisions

### Why Nix Darwin + Home Manager?

- **Declarative Configuration** - All system state defined in code
- **Reproducible Environments** - Same configuration across machines  
- **Atomic Updates** - Changes are applied all-or-nothing
- **Multi-Profile Support** - Different configurations for work/personal

### Apple Silicon Only

This configuration is optimized for Apple Silicon Macs (aarch64-darwin) only:

- Container management via OrbStack (native ARM64)
- All packages built natively without Rosetta
- Two profiles: `personal` and `work`

## Troubleshooting

### Common Issues

- **Hash Mismatches**: Use `nix-prefetch-github owner repo --rev <revision>` to get correct hash
- **Build Failures**: Check if package is available for your architecture
- **Plugin Conflicts**: Remove redundant plugins that conflict with home-manager modules

### Getting Help

1. Check existing issues and documentation
2. Run tests to isolate the problem
3. Verify configuration syntax with `nix flake check`
4. Review recent commit history for similar fixes

## Code Style

### Nix Code

- Use consistent indentation (2 spaces)
- Group related configuration logically  
- Add comments for complex or non-obvious configurations
- Use descriptive variable names

### Fish Code

- Follow Fish shell best practices
- Use functions over aliases for complex operations
- Keep configuration minimal and focused

## Security Considerations  

- Never commit secrets or API keys
- Use environment variables for sensitive configuration
- Regularly update package pins for security fixes
- Review package sources before adding dependencies