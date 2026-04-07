{ config, pkgs, ... }:

{
  # macOS-only packages (GUI applications and platform-specific tools)
  home.packages = with pkgs; [
    # macOS GUI Applications (official packages from nixpkgs)
    raycast
    aerospace
    discord
    vscode
    slack
    spotify
    firefox

    # macOS-specific tools
    mame-tools  # MAME tools including chdman
  ];
}
