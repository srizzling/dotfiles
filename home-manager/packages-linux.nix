{ config, pkgs, ... }:

{
  # Linux-specific packages managed via Nix
  # Note: Most GUI apps (vesktop, freetube, zapzap, spotify, ghostty)
  # are installed via pacman for better Wayland/GPU integration on CachyOS
  home.packages = with pkgs; [
    # Media control
    playerctl
  ];

  # Firefox — install only, let Firefox manage its own profiles
  # Using programs.firefox with profiles breaks existing Firefox profile loading
  programs.firefox.enable = true;
}
