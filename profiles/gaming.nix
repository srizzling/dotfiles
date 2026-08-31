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
  # ~/wallpapers is created by the home.file entry in hyprland.nix.
  home.activation.createGamingDirs = config.lib.dag.entryAfter ["writeBoundary"] ''
    mkdir -p ~/Games
  '';

  # System-level performance tuning script (requires sudo)
  home.file.".local/bin/setup-gaming-perf" = {
    executable = true;
    text = ''
#!/usr/bin/env bash
set -euo pipefail

echo "=== Gaming Performance Setup for CachyOS ==="
echo ""

# ── CPU Governor ──
echo "[1/5] Setting CPU governor to performance..."
if command -v cpupower &>/dev/null; then
  sudo cpupower frequency-set -g performance
  echo "  ✓ CPU governor set to performance"
else
  echo "  ✗ cpupower not found — install with: sudo pacman -S cpupower"
fi

# ── Gamemode config ──
echo "[2/5] Configuring gamemode..."
gamemode_conf="/etc/gamemode.ini"
sudo tee "$gamemode_conf" > /dev/null <<'GAMEMODE'
[general]
renice = 10
ioprio = 0

; No [gpu] section, deliberately. GPU optimisations need nvidia-settings clock
; control, which requires Coolbits in an Xorg config — unavailable under
; Hyprland/Wayland. Enabled, gamemode spawns nvidia-settings on every game
; launch, fails to read GPUGraphicsClockOffset, and logs errors. It also had
; gpu_device = 1 while nvidia-settings enumerates the only card as [gpu:0].

; No desiredgov either: cpu-performance.service below pins the governor to
; performance permanently, so gamemode has nothing to switch and logged
; "Config: Value ignored [cpu] desiredgov=performance" on every start.
GAMEMODE
echo "  ✓ Written $gamemode_conf"

# ── Gamemode group ──
echo "[3/5] Checking gamemode group..."
if ! groups | grep -q gamemode; then
  sudo groupadd -f gamemode
  sudo usermod -aG gamemode "$USER"
  echo "  ✓ Added $USER to gamemode group (log out and back in to take effect)"
else
  echo "  ✓ Already in gamemode group"
fi

# ── Persistent CPU governor via systemd ──
echo "[4/5] Making CPU governor persistent across reboots..."
sudo tee /etc/systemd/system/cpu-performance.service > /dev/null <<'UNIT'
[Unit]
Description=Set CPU governor to performance
After=multi-user.target

[Service]
Type=oneshot
ExecStart=/usr/bin/cpupower frequency-set -g performance
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
UNIT
sudo systemctl daemon-reload
sudo systemctl enable --now cpu-performance.service
echo "  ✓ cpu-performance.service enabled"

# ── sched_ext scheduler ──
# The stock EEVDF scheduler is generic; scx_lavd is latency-optimised and helps
# most on a core-constrained CPU like the 1600X, where frametime consistency
# suffers once threads contend. scx_loader.service is deliberately not used —
# it is a DBus on-demand loader (Type=dbus) and will not hold a scheduler up
# across boot on its own.
echo "[5/5] Enabling scx_lavd sched_ext scheduler..."
if [ ! -e /sys/kernel/sched_ext ]; then
  echo "  ✗ kernel has no sched_ext support — skipping"
elif ! command -v scx_lavd &>/dev/null; then
  echo "  ✗ scx_lavd not found — install with: sudo pacman -S scx-scheds"
else
  sudo tee /etc/systemd/system/scx-lavd.service > /dev/null <<'UNIT'
[Unit]
Description=sched_ext scheduler (scx_lavd)
After=multi-user.target
ConditionPathExists=/sys/kernel/sched_ext

[Service]
Type=simple
ExecStart=/usr/bin/scx_lavd
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
UNIT
  sudo systemctl daemon-reload
  sudo systemctl enable --now scx-lavd.service
  echo "  ✓ scx-lavd.service enabled"
fi

echo ""
echo "=== Done! Verify with: ==="
echo "  cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor"
echo "  cat /sys/kernel/sched_ext/root/ops    # should print: lavd"
echo "  gamemoded -t"
echo ""
echo "Note: gamemoded -t fails its renice check with 'Initial renice value is"
echo "non-zero: 4' when run from a shell that is already renice'd — the"
echo "self-test asserts the process starts at nice 0. Confirmed: running"
echo "'nice -n 4 gamemoded -t' from a nice -4 shell makes the check pass."
echo "ananicy-cpp is active and is what renices the shell. This is a test"
echo "artifact only; gamemode renices games correctly either way."
    '';
  };
}
