{ config, pkgs, profile, ... }:

{
  imports = [
    ./system.nix
  ];

  # Disable nix-darwin's Nix management - Determinate Nix manages the daemon
  nix.enable = false;

  # Allow unfree, broken, and unsupported packages (needed for vscode, slack, raycast, spotify, ghostty, etc.)
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowBroken = true;
  nixpkgs.config.allowUnsupportedSystem = true;

  # Create /etc/zshrc that loads the nix-darwin environment
  programs.zsh.enable = true;
  
  # Set Fish as the default shell for the user
  users.users.srizzling.shell = pkgs.fish;

  # Configure Fish at system level
  programs.fish = {
    enable = true;
    
    # Set PATH for all Fish shells system-wide
    shellInit = ''
      # Add Nix system-wide packages to PATH
      fish_add_path --prepend /run/current-system/sw/bin
      fish_add_path --prepend /nix/var/nix/profiles/default/bin  
      fish_add_path --prepend /etc/profiles/per-user/srizzling/bin
    '';
    
    loginShellInit = ''
      # Add Nix system-wide packages to PATH for login shells
      fish_add_path --prepend /run/current-system/sw/bin
      fish_add_path --prepend /nix/var/nix/profiles/default/bin
      fish_add_path --prepend /etc/profiles/per-user/srizzling/bin
    '';
  };
  
  # Set system-wide environment variables for Nix paths
  environment.variables = {
    PATH = "/run/current-system/sw/bin:/etc/profiles/per-user/srizzling/bin:\${PATH}";
  };

  # Set Git commit hash for darwin-version
  system.configurationRevision = config.rev or config.dirtyRev or null;

  # Set the primary user for system defaults
  system.primaryUser = "srizzling";
  
  # Fix for nix build user group ID mismatch
  ids.gids.nixbld = 350;

  # Used for backwards compatibility, please read the changelog before changing
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # The platform the configuration will be used on
  # This will be set by the flake based on the system parameter
}