{ config, pkgs, lib, ... }:

{
  xdg.configFile."waybar/config.jsonc".text = builtins.toJSON [
    # ── Top bar: workspaces, clock, system info ──
    {
      name = "top";
      layer = "top";
      position = "top";
      height = 34;
      margin-top = 6;
      margin-left = 8;
      margin-right = 8;
      spacing = 4;
      reload_style_on_change = true;

      modules-left = [ "hyprland/workspaces" ];
      modules-center = [ "clock" ];
      modules-right = [ "cpu" "memory" "custom/gpu-temp" "custom/cpu-temp" "custom/pacman-updates" "custom/notifications" "tray" "custom/power" ];

      "hyprland/workspaces" = {
        format = "{icon}";
        format-icons = {
          "1" = "󰎤";
          "2" = "󰎧";
          "B" = "󰈹";
          "C" = "󰨞";
          "T" = "󰆍";
          "G" = "󰊗";
          "S" = "󰓇";
          "M" = "󰍩";
          "E" = "󰇮";
          "N" = "󰗃";
          default = "󰊠";
        };
        on-click = "activate";
        sort-by-number = false;
        persistent-workspaces = {
          "1" = [];
          "2" = [];
          "B" = [];
          "C" = [];
          "T" = [];
          "G" = [];
          "S" = [];
          "M" = [];
        };
      };

      clock = {
        format = "󰥔 {:%H:%M}";
        format-alt = "󰃭 {:%a %d %b · %H:%M}";
        tooltip-format = "<tt><big>{:%B %Y}</big>\n\n{calendar}</tt>";
      };

      cpu = {
        format = " {usage}%";
        interval = 5;
        tooltip-format = "CPU: {usage}% ({load} load avg)";
        on-click = "ghostty -e btop";
      };

      memory = {
        format = "󰍛 {percentage}%";
        interval = 10;
        tooltip-format = "RAM: {used:0.1f}G / {total:0.1f}G";
        on-click = "ghostty -e btop";
      };

      "custom/cpu-temp" = {
        format = "󱃃 {}°";
        exec = "awk '{printf \"%.0f\", $1/1000}' /sys/class/hwmon/hwmon1/temp1_input";
        interval = 5;
        tooltip = "CPU Temperature";
      };

      "custom/gpu-temp" = {
        format = "󰢮 {}°";
        exec = "nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits 2>/dev/null || echo '?'";
        interval = 5;
        tooltip = "GPU Temperature";
      };

      "custom/pacman-updates" = {
        format = "󰏔 {text}";
        format-icons = {
          has-updates = "󰏔";
          updated = "󰄬";
        };
        exec = "waybar-module-pacman-updates";
        return-type = "json";
        on-click = "ghostty -e cachy-update";
      };

      "custom/notifications" = {
        tooltip = false;
        format = "{icon} {text}";
        format-icons = {
          notification = "󰂚";
          none = "󰂜";
          dnd-notification = "󰂛";
          dnd-none = "󰪑";
          inhibited-notification = "󰂚";
          inhibited-none = "󰂜";
          dnd-inhibited-notification = "󰂛";
          dnd-inhibited-none = "󰪑";
        };
        return-type = "json";
        exec = "swaync-client -swb";
        on-click = "swaync-client -t -sw";
        on-click-right = "swaync-client -d -sw";
        escape = true;
      };

      tray = {
        icon-size = 16;
        spacing = 6;
      };

      "custom/power" = {
        format = "⏻";
        tooltip = false;
        on-click = "echo -e '  Lock\n  Logout\n  Restart\n⏻  Shutdown' | fuzzel --dmenu -w 20 -l 4 | xargs -I{} sh -c 'case \"{}\" in *Lock*) hyprlock;; *Logout*) hyprctl dispatch exit;; *Restart*) systemctl reboot;; *Shutdown*) systemctl poweroff;; esac'";
      };
    }

  ];

  xdg.configFile."waybar/style.css".text = ''
    @define-color base    #191724;
    @define-color surface #1f1d2e;
    @define-color overlay #26233a;
    @define-color muted   #6e6a86;
    @define-color subtle  #908caa;
    @define-color text    #e0def4;
    @define-color love    #eb6f92;
    @define-color gold    #f6c177;
    @define-color rose    #ebbcba;
    @define-color pine    #31748f;
    @define-color foam    #9ccfd8;
    @define-color iris    #c4a7e7;

    * {
        font-family: "Iosevka Nerd Font", "Iosevka NF";
        font-size: 12px;
        min-height: 0;
        padding: 0;
        margin: 0;
    }

    window#waybar, window#waybar > box {
        background: transparent;
        color: @text;
    }

    /* ── pill base ── */
    #workspaces,
    #clock,
    #cpu,
    #memory,
    #custom-cpu-temp,
    #custom-gpu-temp,
    #custom-pacman-updates,
    #custom-notifications,
    #custom-power,
    #tray {
        background: alpha(@base, 0.9);
        border: 1px solid alpha(@overlay, 0.5);
        border-radius: 8px;
        padding: 4px 12px;
        margin: 3px 0;
        transition: all 200ms cubic-bezier(.4, 0, .2, 1);
    }

    /* ── workspaces (iris) ── */
    #workspaces {
        padding: 2px 3px;
    }

    #workspaces button {
        color: @muted;
        padding: 2px 8px;
        margin: 1px;
        border-radius: 6px;
        background: transparent;
        border: none;
    }

    #workspaces button.active {
        color: @base;
        background: @iris;
        font-weight: bold;
    }

    #workspaces button.visible {
        color: @text;
        background: alpha(@iris, 0.25);
    }

    #workspaces button.urgent {
        color: @base;
        background: @love;
    }

    #workspaces button:hover {
        color: @text;
        background: alpha(@overlay, 0.5);
    }

    /* ── clock (rose) ── */
    #clock {
        color: @rose;
        font-weight: bold;
    }

    /* ── cpu usage (pine) ── */
    #cpu {
        color: @pine;
    }

    /* ── memory (foam) ── */
    #memory {
        color: @foam;
    }

    /* ── cpu temp (gold) ── */
    #custom-cpu-temp {
        color: @gold;
    }

    /* ── gpu temp (foam) ── */
    #custom-gpu-temp {
        color: @foam;
    }

    /* ── updates (iris) ── */
    #custom-pacman-updates {
        color: @iris;
    }

    /* ── notifications (rose) ── */
    #custom-notifications {
        color: @rose;
    }

    /* ── power (love) ── */
    #custom-power {
        color: @love;
        padding: 4px 10px;
    }

    /* ── tray ── */
    #tray {
        padding: 4px 8px;
    }

    #tray > .passive {
        -gtk-icon-effect: dim;
    }

    #tray > .needs-attention {
        -gtk-icon-effect: highlight;
        color: @love;
    }

    /* ── hover ── */
    #clock:hover,
    #cpu:hover,
    #memory:hover,
    #custom-cpu-temp:hover,
    #custom-gpu-temp:hover,
    #custom-pacman-updates:hover,
    #custom-notifications:hover,
    #custom-power:hover,
    #tray:hover {
        background: alpha(@surface, 0.9);
        border-color: alpha(@muted, 0.4);
    }

    /* ── tooltips ── */
    tooltip {
        background: alpha(@base, 0.9);
        border: 1px solid @overlay;
        border-radius: 8px;
        padding: 6px;
    }

    tooltip label {
        color: @text;
    }
  '';
}
