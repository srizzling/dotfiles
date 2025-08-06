{ config, pkgs, lib, ... }:

{
  # Development packages (migrated from devbox global)
  environment.systemPackages = with pkgs; [
    # Linting and validation tools (from devbox.json)
    yamllint
    nodePackages.jsonlint
    shellcheck
    gh                              # GitHub CLI

    # Essential CLI tools
    fish
    direnv
    fzf
    ripgrep                         # Better grep
    fd                              # Better find
    zoxide                          # Better cd (replaces z)
    
    # Development utilities
    git
    vim
    curl
    wget
    jq                              # JSON processing
    
    # Node.js for claude-code and other npm packages
    nodejs
  ];

  # Services
  services = {
    # No need to enable fish service here, done in darwin-base.nix
  };
}