{ config, pkgs, ... }:

{
  # Personal profile configuration
  
  # Git configuration for personal projects
  programs.git.settings.user = {
    name = "Sriram Venkatesh";
    email = "venksriram@gmail.com";
  };

  # Personal-specific environment variables
  home.sessionVariables = {
    # Add personal-specific variables here
  };

  # Personal-specific packages (if any)
  home.packages = with pkgs; [
    # Add personal-only packages here
  ];
  
  # Create personal development directory
  home.activation.createPersonalDirs = config.lib.dag.entryAfter ["writeBoundary"] ''
    mkdir -p ~/development/personal
  '';
}