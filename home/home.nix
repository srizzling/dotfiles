{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./shell/fish.nix
    ./development/git.nix
  ];

  # Home Manager settings
  home = {
    username = "srizzling";
    homeDirectory = "/Users/srizzling";
    stateVersion = "23.11";

    # Global npm packages
    activation.claude-code = lib.hm.dag.entryAfter ["writeBoundary"] ''
      # Install claude-code via npm (more up-to-date than nixpkgs)
      ${pkgs.nodejs}/bin/npm install -g @anthropic-ai/claude-code 2>/dev/null || true
    '';
  };

  # Let Home Manager manage itself
  programs.home-manager.enable = true;

  # Starship prompt configuration
  programs.starship = {
    enable = true;
    settings = {
      # Import existing starship config later
      add_newline = false;
      format = "$all$character";
    };
  };
}