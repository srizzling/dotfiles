{ config, pkgs, ... }:

{
  # Gaming profile for CachyOS/Hyprland machine

  # Git configuration (same as personal)
  programs.git = {
    userName = "Sriram Venkatesh";
    userEmail = "venksriram@gmail.com";
  };

  # Gaming-specific environment variables
  home.sessionVariables = {
    STEAM_FORCE_DESKTOPUI_SCALING = "1.5";  # Scale Steam UI for 4K monitor
  };

  # Gaming tools available via Nix
  home.packages = with pkgs; [
    gamemode
    mangohud
  ];

  # Create gaming directories
  home.activation.createGamingDirs = config.lib.dag.entryAfter ["writeBoundary"] ''
    mkdir -p ~/Games
    mkdir -p ~/wallpapers
  '';
}
