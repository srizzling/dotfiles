{ config, pkgs, ... }:

{
  # Linux-specific packages managed via Nix
  # Note: Most GUI apps (vesktop, freetube, zapzap, spotify, ghostty)
  # are installed via pacman for better Wayland/GPU integration on CachyOS
  home.packages = with pkgs; [
    # Media control
    playerctl
  ];

  # Firefox managed via programs.firefox for theme integration
  programs.firefox = {
    enable = true;
    profiles.default = {
      isDefault = true;
      extensions.force = true;
      settings = {
        # Dark theme
        "browser.theme.content-theme" = 0;
        "browser.theme.toolbar-theme" = 0;
        "ui.systemUsesDarkTheme" = 1;
        # Wayland native
        "widget.use-xdg-desktop-portal.file-picker" = 1;
        # Performance
        "gfx.webrender.all" = true;
        "media.ffmpeg.vaapi.enabled" = true;
      };
    };
  };
}
