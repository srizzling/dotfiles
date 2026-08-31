{ config, pkgs, lib, ... }:

let
  # Rose Pine palette
  rosePineColors = {
    mError = "#eb6f92";
    mOnError = "#191724";
    mOnPrimary = "#191724";
    mOnSecondary = "#191724";
    mOnSurface = "#e0def4";
    mOnSurfaceVariant = "#908caa";
    mOnTertiary = "#191724";
    mOutline = "#6e6a86";
    mPrimary = "#c4a7e7";
    mSecondary = "#ebbcba";
    mShadow = "#0a0814";
    mSurface = "#191724";
    mSurfaceVariant = "#1f1d2e";
    mTertiary = "#9ccfd8";
  };

  noctaliaSettings = {
    bar = {
      position = "top";
      density = "default";
      barType = "floating";
      monitors = [ "DP-1" "DP-2" ];
      marginHorizontal = 8;
      marginVertical = 6;
      showCapsule = true;
      widgets = {
        left = [
          { id = "Launcher"; }
          {
            id = "Workspace";
            labelMode = "name";
            hideUnoccupied = false;
            showLabelsOnlyWhenOccupied = false;
            showApplications = true;
            showApplicationsHover = false;
          }
          { id = "ActiveWindow"; }
        ];
        center = [
          { id = "Clock"; formatHorizontal = "HH:mm"; }
        ];
        right = [
          { id = "SystemMonitor"; }
          { id = "Volume"; }
          { id = "Tray"; }
          { id = "NotificationHistory"; }
          { id = "PowerProfile"; }
        ];
      };
    };

    notifications = {
      doNotDisturb = false;
      location = "top_right";
    };

    general = {
      avatarImage = "";
      radiusRatio = 1.0;
      animationSpeed = 1.0;
      dimDesktop = false;
    };

    audio = {
      volumeStep = 5;
      volumeOverdrive = false;
    };

    idle = {
      enabled = false;
      dimOnTimeout = false;
      dimTimeout = 300;
      lockOnTimeout = false;
      lockTimeout = 600;
      dpmsOnTimeout = false;
      dpmsTimeout = 900;
      sleepOnTimeout = false;
    };

    # Noctalia draws its own opaque wallpaper layer in the background layer,
    # stacked above anything awww paints — so it, not awww, owns the desktop
    # background. Point it at the in-repo wallpapers directory (see the
    # home.file entry in hyprland.nix) rather than its default ~/Pictures.
    wallpaper = {
      enabled = true;
      directory = "${config.home.homeDirectory}/wallpapers";
      # The tracked wallpaper is 1672x941 — smaller than either monitor, so
      # crop-to-fill rather than letterbox against the fill colour.
      fillMode = "crop";
      setWallpaperOnAllMonitors = true;
      automationEnabled = false;
    };

    # Lock screen is owned by hyprlock/hypridle (see hyprlock.nix), which has a
    # real layout surface. Disabled here so only one locker answers logind.
    lockScreen = {
      enabled = false;
      showClock = true;
      showUser = true;
    };
  };

  jsonFormat = pkgs.formats.json { };
in
{
  # Noctalia-shell itself is installed via pacman (`sudo pacman -S noctalia-shell`)
  # on CachyOS — Nix-built quickshell can't create GL contexts on non-NixOS, so
  # we keep the binary native and only manage config declaratively.

  xdg.configFile."noctalia/settings.json".source =
    jsonFormat.generate "noctalia-settings.json" noctaliaSettings;

  xdg.configFile."noctalia/colors.json".source =
    jsonFormat.generate "noctalia-colors.json" rosePineColors;

  # PAM service for noctalia's built-in lockscreen.
  xdg.configFile."noctalia/pam.d/noctalia".text = ''
    auth    include  system-auth
    account include  system-auth
  '';

  home.file.".local/bin/install-noctalia-pam" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      set -euo pipefail
      src="$HOME/.config/noctalia/pam.d/noctalia"
      dst="/etc/pam.d/noctalia"
      if [ ! -f "$src" ]; then
        echo "missing $src — run home-manager switch first" >&2
        exit 1
      fi
      sudo install -m 644 "$src" "$dst"
      echo "installed $dst"
    '';
  };

  home.sessionVariables.NOCTALIA_PAM_SERVICE = "noctalia";
}
