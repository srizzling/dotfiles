{ config, pkgs, lib, profile, ... }:

{
  imports = [
    ./packages-common.nix
    ./packages-darwin.nix
    ./shell.nix
    ./git.nix
    ./aerospace.nix
    ./raycast.nix
    ./ghostty.nix
    ./lsd.nix
    ./catppuccin.nix
    ../profiles/${profile}.nix
  ];

  # Home Manager needs a bit of information about you and the
  # paths it should manage  
  # Note: username and homeDirectory are set in flake.nix

  # This value determines the Home Manager release that your
  # configuration is compatible with
  home.stateVersion = "25.05";

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # Basic shell setup
  home.sessionVariables = {
    EDITOR = "vim";
    VISUAL = lib.mkForce "code";
    WEDITOR = "code";
  };

  # XDG directories
  xdg.enable = true;

  # Set Firefox as default browser (macOS compatible)
  home.sessionVariables.BROWSER = "firefox";

  # Claude development instructions
  home.file."CLAUDE.md".text = ''
    # Git Commit Instructions for Claude

    When making git commits, ALWAYS use the Fish shell git functions instead of regular git commands.

    ## Commit Function Format

    Use: `fish -c "g<type> '<scope>' '<subject>' -b '<body>'"`

    Where:
    - `<type>` is one of: feat, fix, docs, style, ref, test, chore, perf, ci, depup, depdown, wip
    - `<scope>` is the area of change (e.g., nix, shell, aerospace, etc.)
    - `<subject>` is a brief description of the change
    - `<body>` (optional) is additional details about the change

    ## Available Types

    - `gfeat` - New features (✨)
    - `gfix` - Bug fixes (🐛)
    - `gdocs` - Documentation (📝)
    - `gstyle` - Code style/formatting (🎨)
    - `gref` - Refactoring (♻️)
    - `gtest` - Tests (✅)
    - `gchore` - Maintenance tasks (🧹)
    - `gperf` - Performance improvements (⚡)
    - `gci` - CI/CD changes (👷)
    - `gdepup` - Dependency upgrades (⬆)
    - `gdepdown` - Dependency downgrades (⬇️)
    - `gwip` - Work in progress (🚧)

    ## Examples

    ```bash
    fish -c "gfeat 'shell' 'add new Fish completion' -b 'Added tab completion for custom commands'"
    fish -c "gfix 'nix' 'resolve package hash mismatch'"
    fish -c "gdocs 'readme' 'update installation instructions'"
    ```

    ## Important Notes

    - ALWAYS use `fish -c` to execute these commands
    - These functions automatically format commits with proper emoji and structure
    - The functions are only available in Fish shell, not bash/zsh
    - Use single quotes around parameters to avoid shell interpolation issues

    # Development Environments

    Every project under `~/development/personal/` and `~/development/work/` uses
    devenv for its development environment. This is a rule, not a preference.

    ## What this means

    - Define the environment in `devenv.nix`, with `devenv.yaml` for inputs.
    - Activate it through direnv: an `.envrc` containing `use devenv`. That one
      line is enough — devenv's direnvrc is installed globally, so projects do
      not need devenv's `eval "$(devenv direnvrc)"` bootstrap.
    - Everything a project needs to build, test and run belongs in `devenv.nix`,
      so a clean checkout plus `direnv allow` is enough to start working.

    ## Setting up a project

    Run `devinit` in the project directory. It scaffolds `devenv.nix`,
    `devenv.yaml` and `.envrc`, then runs `direnv allow`. It refuses to run
    outside the two directories above, refuses to overwrite an existing
    `devenv.nix`, and warns when a competing environment file is still present.

    ## Do not introduce alternatives

    Never set up a project with a bare `shell.nix`, a `devbox.json`, a language
    version manager (asdf, nvm, pyenv, rbenv, rustup), a Homebrew install, or a
    globally installed toolchain to satisfy a project dependency. If a tool is
    needed to work on a project, it goes in that project's `devenv.nix`.

    ## Existing projects

    Some projects predate this rule and use a bare `flake.nix` devShell. Migrate
    one to devenv when you are next reworking its environment, and never leave a
    project configured with both at once.
  '';
}