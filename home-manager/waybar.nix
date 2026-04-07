{ config, pkgs, lib, ... }:

{
  xdg.configFile."waybar/config.jsonc".text = builtins.toJSON {
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
    modules-right = [ "custom/gpu-temp" "custom/cpu-temp" "custom/cachyos-updates" ];

    "hyprland/workspaces" = {
      format = "{name}";
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
      format = "{:%H:%M}";
      format-alt = "{:%a %d %b · %H:%M}";
      tooltip-format = "<tt><big>{:%B %Y}</big>\n\n{calendar}</tt>";
    };

    "custom/cpu-temp" = {
      format = "CPU {}°";
      exec = "awk '{printf \"%.0f\", $1/1000}' /sys/class/hwmon/hwmon1/temp1_input";
      interval = 5;
    };

    "custom/gpu-temp" = {
      format = "GPU {}°";
      exec = "nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits 2>/dev/null || echo '?'";
      interval = 5;
    };

    "custom/cachyos-updates" = {
      format = "UPD {}";
      exec = "checkupdates 2>/dev/null | wc -l";
      interval = 600;
      on-click = "ghostty -e paru -Syu";
    };
  };

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
        font-family: "Iosevka NFM";
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
    #custom-cpu-temp,
    #custom-gpu-temp,
    #custom-cachyos-updates {
        background: alpha(@base, 0.9);
        border: 1px solid alpha(@overlay, 0.5);
        border-radius: 8px;
        padding: 4px 12px;
        margin: 3px 0;
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

    /* ── cpu temp (gold) ── */
    #custom-cpu-temp {
        color: @gold;
    }

    /* ── gpu temp (foam) ── */
    #custom-gpu-temp {
        color: @foam;
    }

    /* ── updates (iris) ── */
    #custom-cachyos-updates {
        color: @iris;
    }

    /* ── hover ── */
    #clock:hover,
    #custom-cpu-temp:hover,
    #custom-gpu-temp:hover,
    #custom-cachyos-updates:hover {
        background: alpha(@surface, 0.9);
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
