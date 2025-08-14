{ config, pkgs, profile, ... }:

{
  # Note: allowUnfree is configured at system level when using useGlobalPkgs
  # User packages - migrated from devbox global
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
    python310
    zoxide

    # Additional useful packages
    jq
    ripgrep
    tree
    htop
    
    # Development tools
    gh  # GitHub CLI
    just  # Command runner
    devbox  # Isolated development environments
    claude-code  # Agentic coding tool by Anthropic
    cocogitto  # Conventional commits toolbox
    mame-tools  # MAME tools including chdman
    
    # Fish shell tools
    fishPlugins.fishtape  # TAP-compliant test runner for Fish
    
    # Fonts
    nerd-fonts.iosevka  # Iosevka NFM font for Ghostty
    
    # GUI Applications (official packages from nixpkgs)
    raycast
    aerospace
    # ghostty  # Terminal emulator - build issues on this system
    discord
    vscode
    slack
    spotify
    spotify-player  # Terminal-based spotify client
    firefox
    # whatsapp-for-linux  # Removed - Linux only package causing build issues
  ];

  # Enable direnv integration
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

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