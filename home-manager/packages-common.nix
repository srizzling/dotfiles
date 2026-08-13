{ config, pkgs, ... }:

{
  # Note: allowUnfree is configured at system level when using useGlobalPkgs
  # Cross-platform CLI tools and configurations shared between macOS and Linux
  home.packages = with pkgs; [
    # Core utilities (from devbox global)
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

  # Make `use devenv` available to every .envrc without per-project boilerplate.
  # direnv sources everything in this lib directory before evaluating an .envrc,
  # so projects need only `use devenv` rather than devenv's documented
  # `eval "$(devenv direnvrc)"` line repeated in each one. Evaluated at load
  # time rather than baked in, so it stays correct across devenv upgrades —
  # `devenv direnvrc` is a ~60ms static print.
  xdg.configFile."direnv/lib/devenv.sh".text = ''
    eval "$(${pkgs.devenv}/bin/devenv direnvrc)"
  '';

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
