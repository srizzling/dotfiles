{ config, pkgs, ... }:

{
  # Note: allowUnfree is configured at system level when using useGlobalPkgs
  # Cross-platform CLI tools and configurations shared between macOS and Linux
  home.packages = with pkgs; [
    # Core utilities
    bat
    curl
    direnv
    fd
    fzf
    git
    git-absorb
    delta
    grc
    gum
    lsd
    starship
    wget
    python3
    zoxide

    # Additional useful packages
    jq
    ripgrep
    tree
    htop

    # Development tools
    gh  # GitHub CLI
    just  # Command runner
    devenv  # Standard dev environment for projects under ~/development
    claude-code  # Agentic coding tool by Anthropic
    cocogitto  # Conventional commits toolbox

    # Fish shell tools
    fishPlugins.fishtape  # TAP-compliant test runner for Fish

    # Fonts
    nerd-fonts.iosevka  # Iosevka NFM font for terminal

    # Terminal music client
    spotify-player  # Terminal-based spotify client
  ];

  # Enable direnv integration
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # devenv's direnvrc is deliberately NOT installed into ~/.config/direnv/lib.
  # Both it and nix-direnv define _nix_direnv_preflight, and direnv sources that
  # directory alphabetically, so nix-direnv's copy (hm-nix-direnv.sh) would
  # override devenv's (devenv.sh). `use devenv` then calls the wrong preflight,
  # DEVENV_BIN is never set, and the shell silently fails to build.
  #
  # Projects use devenv's documented two-line .envrc instead, which is evaluated
  # after the lib directory and therefore wins:
  #
  #   eval "$(devenv direnvrc)"
  #   use devenv
  #
  # `devinit` writes both lines, so this costs nothing per project.

  # Configure vim editor
  programs.vim = {
    enable = true;
    defaultEditor = true;
    extraConfig = ''
      " Motivated by https://robots.thoughtbot.com/5-useful-tips-for-a-better-commit-message
      set noexrc                             " do NOT read .vimrc within every directory

      syntax on " Turn on color syntax and allow custom Git commit message messages
      autocmd Filetype gitcommit setlocal spell textwidth=72 " Spell check git commit messages and wrap text at column 72
    '';
  };

  # Configure zoxide (better z)
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  # Configure fzf
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  # Configure GitHub CLI
  programs.gh = {
    enable = true;
    settings = {
      version = 1;
      git_protocol = "https";
      prompt = "enabled";
      prefer_editor_prompt = "disabled";
      color_labels = "disabled";
      accessible_colors = "disabled";
      accessible_prompter = "disabled";
      spinner = "enabled";
      aliases = {
        co = "pr checkout";
      };
    };
  };
}
