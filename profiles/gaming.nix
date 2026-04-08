{ config, pkgs, ... }:

{
  # Gaming profile for CachyOS/Hyprland machine

  # Git configuration (same as personal)
  programs.git.settings.user = {
    name = "Sriram Venkatesh";
    email = "venksriram@gmail.com";
  };

  # Gaming-specific environment variables
  home.sessionVariables = {
    STEAM_FORCE_DESKTOPUI_SCALING = "1.5";  # Scale Steam UI for 4K monitor
    MANGOHUD = "1";                          # Enable MangoHud globally for Vulkan games
    MANGOHUD_DLSYM = "1";                   # Also hook OpenGL games
  };

  # Gaming tools available via Nix
  home.packages = with pkgs; [
    mangohud
  ];

  # MangoHud configuration — Rose Pine themed HUD overlay
  xdg.configFile."MangoHud/MangoHud.conf".text = ''
    # ── Layout ──
    position=top-left
    round_corners=8
    table_columns=3
    font_size=18

    # ── Display ──
    fps
    frametime=0
    gpu_stats
    gpu_temp
    gpu_power
    gpu_load_change
    cpu_stats
    cpu_temp
    cpu_power
    cpu_load_change
    ram
    vram
    gamemode
    resolution
    vulkan_driver

    # ── Rose Pine Colors ──
    background_alpha=0.7
    background_color=191724
    text_color=e0def4
    gpu_color=9ccfd8
    cpu_color=c4a7e7
    ram_color=f6c177
    vram_color=ebbcba
    engine_color=31748f
    frametime_color=eb6f92
    media_player_color=908caa

    # ── Behavior ──
    toggle_hud=Shift_R+F12
    toggle_fps_limit=Shift_R+F11
  '';

  # Create gaming directories
  home.activation.createGamingDirs = config.lib.dag.entryAfter ["writeBoundary"] ''
    mkdir -p ~/Games
    mkdir -p ~/wallpapers
  '';
}
