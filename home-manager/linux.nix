{ config, pkgs, lib, ... }:

{
  imports = [
    ./packages-common.nix
    ./packages-linux.nix
    ./shell.nix
    ./git.nix
    ./lsd.nix
    ./catppuccin.nix
    ./hyprland.nix
    ./waybar.nix
    ./fuzzel.nix
    ./dunst.nix
    ../profiles/gaming.nix
  ];

  # Allow unfree packages (standalone home-manager doesn't inherit system config)
  nixpkgs.config.allowUnfree = true;

  # Home Manager configuration
  home.username = "srizzling";
  home.homeDirectory = "/home/srizzling";
  home.stateVersion = "25.05";

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # Basic shell setup
  home.sessionVariables = {
    EDITOR = "vim";
    VISUAL = lib.mkForce "code";
    WEDITOR = "code";
    BROWSER = "firefox";
  };

  # XDG directories
  xdg.enable = true;

  # Calendar popup script (Rose Pine themed, togglable)
  home.file.".local/bin/calendar-popup" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      # Toggle a Rose Pine themed calendar popup

      # Kill existing instance if running
      if pidof yad | grep -q .; then
        pkill -f "yad --calendar"
        exit 0
      fi

      # Get monitor geometry for positioning (center-top)
      MONITOR=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | "\(.width/(.scale))x\(.height/(.scale))+\(.x)+\(.y)"')
      MON_W=$(echo $MONITOR | cut -d'x' -f1 | cut -d'.' -f1)
      MON_X=$(echo $MONITOR | cut -d'+' -f2)

      # Calendar popup width and position
      CAL_W=340
      POS_X=$(( MON_X + (MON_W / 2) - (CAL_W / 2) ))
      POS_Y=48

      # Rose Pine themed calendar
      export GTK_THEME=Adwaita:dark
      yad --calendar \
        --undecorated \
        --fixed \
        --close-on-unfocus \
        --no-buttons \
        --width=$CAL_W \
        --posx=$POS_X \
        --posy=$POS_Y \
        --title="calendar" \
        --borders=12 2>/dev/null &
    '';
  };

  # GTK Rose Pine theme for popups and GTK apps
  home.file.".config/gtk-3.0/gtk.css".text = ''
    /* Rose Pine dark overrides for GTK3 apps */
    @define-color theme_bg_color #191724;
    @define-color theme_fg_color #e0def4;
    @define-color theme_base_color #1f1d2e;
    @define-color theme_text_color #e0def4;
    @define-color theme_selected_bg_color #c4a7e7;
    @define-color theme_selected_fg_color #191724;

    window, dialog {
      background-color: #191724;
      color: #e0def4;
    }

    calendar {
      background-color: #191724;
      color: #e0def4;
      border-radius: 8px;
    }

    calendar:header {
      background-color: #26233a;
      color: #ebbcba;
      border-radius: 8px 8px 0 0;
    }

    calendar:selected {
      background-color: #c4a7e7;
      color: #191724;
      border-radius: 4px;
    }

    calendar.highlight {
      color: #c4a7e7;
      font-weight: bold;
    }

    calendar:indeterminate {
      color: #6e6a86;
    }

    button {
      background-color: #26233a;
      color: #e0def4;
      border: 1px solid #403d52;
      border-radius: 6px;
      padding: 4px 8px;
    }

    button:hover {
      background-color: #403d52;
    }

    button:active, button:checked {
      background-color: #c4a7e7;
      color: #191724;
    }
  '';

  # Vesktop/Vencord — Rose Pine theme CSS
  # Using home.file to write into vesktop's existing themes directory
  home.file.".config/vesktop/themes/rose-pine.css".text = ''
    /**
     * @name Rosé Pine
     * @author rose-pine
     * @version 1.0.0
     */
    :root {
        --rp-base: #191724;
        --rp-surface: #1f1d2e;
        --rp-overlay: #26233a;
        --rp-muted: #6e6a86;
        --rp-subtle: #908caa;
        --rp-text: #e0def4;
        --rp-love: #eb6f92;
        --rp-gold: #f6c177;
        --rp-rose: #ebbcba;
        --rp-pine: #31748f;
        --rp-foam: #9ccfd8;
        --rp-iris: #c4a7e7;
        --rp-highlight-low: #21202e;
        --rp-highlight-med: #403d52;
        --rp-highlight-high: #524f67;
    }

    .theme-dark {
        --background-primary: var(--rp-base);
        --background-secondary: var(--rp-surface);
        --background-secondary-alt: var(--rp-overlay);
        --background-tertiary: var(--rp-base);
        --background-accent: var(--rp-overlay);
        --background-floating: var(--rp-surface);
        --background-modifier-hover: var(--rp-highlight-low);
        --background-modifier-active: var(--rp-highlight-med);
        --background-modifier-selected: var(--rp-highlight-low);
        --background-modifier-accent: var(--rp-highlight-med);
        --channels-default: var(--rp-subtle);
        --channel-icon: var(--rp-subtle);
        --header-primary: var(--rp-text);
        --header-secondary: var(--rp-subtle);
        --text-normal: var(--rp-text);
        --text-muted: var(--rp-muted);
        --text-link: var(--rp-foam);
        --interactive-normal: var(--rp-subtle);
        --interactive-hover: var(--rp-text);
        --interactive-active: var(--rp-text);
        --interactive-muted: var(--rp-muted);
        --scrollbar-thin-thumb: var(--rp-highlight-med);
        --scrollbar-thin-track: transparent;
        --scrollbar-auto-thumb: var(--rp-highlight-med);
        --scrollbar-auto-track: var(--rp-base);
        --brand-experiment: var(--rp-iris);
        --brand-experiment-560: var(--rp-iris);
        --focus-primary: var(--rp-iris);
        --input-background: var(--rp-overlay);
        --modal-background: var(--rp-surface);
        --card-primary-bg: var(--rp-surface);
        --activity-card-background: var(--rp-surface);
        --button-secondary-background: var(--rp-overlay);
        --mention-foreground: var(--rp-iris);
        --mention-background: rgba(196, 167, 231, 0.1);
        --info-positive-foreground: var(--rp-foam);
        --info-warning-foreground: var(--rp-gold);
        --info-danger-foreground: var(--rp-love);
        --status-positive: var(--rp-foam);
        --status-warning: var(--rp-gold);
        --status-danger: var(--rp-love);
    }
  '';


  # Claude development instructions
  home.file."CLAUDE.md".text = ''
    # Git Commit Instructions for Claude

    When making git commits, ALWAYS use the Fish shell git functions instead of regular git commands.

    ## Commit Function Format

    Use: `fish -c "g<type> '<scope>' '<subject>' -b '<body>'"`

    Where:
    - `<type>` is one of: feat, fix, docs, style, ref, test, chore, perf, ci, depup, depdown, wip
    - `<scope>` is the area of change (e.g., nix, shell, hyprland, etc.)
    - `<subject>` is a brief description of the change
    - `<body>` (optional) is additional details about the change

    ## Available Types

    - `gfeat` - New features (✨)
    - `gfix` - Bug fixes (🐛)
    - `gdocs` - Documentation (📝)
    - `gstyle` - Code style/formatting (🎨)
    - `gref` - Refactoring (♻️)
    - `gtest` - Tests (✅)
    - `gchore` - Maintenance tasks (🧹)
    - `gperf` - Performance improvements (⚡)
    - `gci` - CI/CD changes (👷)
    - `gdepup` - Dependency upgrades (⬆)
    - `gdepdown` - Dependency downgrades (⬇️)
    - `gwip` - Work in progress (🚧)

    ## Examples

    ```bash
    fish -c "gfeat 'shell' 'add new Fish completion' -b 'Added tab completion for custom commands'"
    fish -c "gfix 'nix' 'resolve package hash mismatch'"
    fish -c "gdocs 'readme' 'update installation instructions'"
    ```

    ## Important Notes

    - ALWAYS use `fish -c` to execute these commands
    - These functions automatically format commits with proper emoji and structure
    - The functions are only available in Fish shell, not bash/zsh
    - Use single quotes around parameters to avoid shell interpolation issues
  '';
}
