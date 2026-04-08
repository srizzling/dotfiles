{ config, pkgs, lib, ... }:

{
  # SwayNotificationCenter — Rose Pine themed notification daemon with panel
  # Replaces dunst; provides aggregated notification panel + waybar integration
  xdg.configFile."swaync/config.json".text = builtins.toJSON {
    "$schema" = "/etc/xdg/swaync/configSchema.json";
    positionX = "right";
    positionY = "top";
    layer = "overlay";
    control-center-layer = "top";
    layer-shell = true;
    cssPriority = "application";
    control-center-margin-top = 8;
    control-center-margin-bottom = 8;
    control-center-margin-right = 8;
    control-center-width = 380;
    notification-2fa-action = true;
    notification-inline-replies = false;
    notification-icon-size = 48;
    notification-body-image-height = 100;
    notification-body-image-width = 200;
    timeout = 6;
    timeout-low = 4;
    timeout-critical = 0;
    fit-to-screen = true;
    notification-window-width = 360;
    keyboard-shortcuts = true;
    image-visibility = "when-available";
    transition-time = 200;
    hide-on-clear = false;
    hide-on-action = true;
    script-fail-notify = true;
    widgets = [
      "inhibitors"
      "title"
      "dnd"
      "notifications"
    ];
    widget-config = {
      inhibitors = {
        text = "Inhibitors";
        button-text = "Clear All";
        clear-all-button = true;
      };
      title = {
        text = "Notifications";
        clear-all-button = true;
        button-text = "Clear All";
      };
      dnd = {
        text = "Do Not Disturb";
      };
    };
  };

  xdg.configFile."swaync/style.css".text = ''
    /* Rose Pine — SwayNC */
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
    @define-color hl_low  #21202e;
    @define-color hl_med  #403d52;

    /* ── control center (panel) ── */
    .control-center {
        background: alpha(@base, 0.95);
        border: 1px solid @overlay;
        border-radius: 12px;
        padding: 8px;
        color: @text;
    }

    .control-center .notification-row {
        padding: 0;
    }

    /* ── title bar ── */
    .widget-title {
        color: @text;
        font-weight: bold;
        font-size: 13px;
        margin: 4px 8px;
    }

    .widget-title > button {
        background: @overlay;
        color: @subtle;
        border: none;
        border-radius: 6px;
        padding: 4px 12px;
        font-size: 11px;
    }

    .widget-title > button:hover {
        background: @hl_med;
        color: @text;
    }

    /* ── DND toggle ── */
    .widget-dnd {
        margin: 4px 8px;
        color: @subtle;
        font-size: 12px;
    }

    .widget-dnd > switch {
        background: @overlay;
        border-radius: 12px;
        border: none;
    }

    .widget-dnd > switch:checked {
        background: @iris;
    }

    .widget-dnd > switch slider {
        background: @text;
        border-radius: 50%;
    }

    /* ── notification popups ── */
    .notification-row {
        outline: none;
    }

    .notification {
        background: @surface;
        border: 1px solid alpha(@overlay, 0.6);
        border-radius: 8px;
        padding: 0;
        margin: 4px 0;
        transition: all 200ms ease;
    }

    .notification:hover {
        background: @overlay;
    }

    .notification-content {
        padding: 10px 14px;
    }

    .summary {
        color: @text;
        font-weight: bold;
        font-size: 12px;
    }

    .body {
        color: @subtle;
        font-size: 11px;
    }

    .time {
        color: @muted;
        font-size: 10px;
    }

    .image {
        border-radius: 6px;
        margin-right: 10px;
    }

    .close-button {
        background: @overlay;
        color: @subtle;
        border: none;
        border-radius: 50%;
        min-width: 20px;
        min-height: 20px;
        padding: 0;
    }

    .close-button:hover {
        background: @love;
        color: @base;
    }

    /* ── critical notifications ── */
    .critical {
        border-left: 3px solid @love;
    }

    .critical .summary {
        color: @love;
    }

    /* ── notification actions ── */
    .notification-action {
        background: @overlay;
        color: @subtle;
        border: none;
        border-radius: 6px;
        padding: 4px 12px;
        margin: 4px 2px;
    }

    .notification-action:hover {
        background: @hl_med;
        color: @text;
    }

    /* ── floating notifications (popup) ── */
    .floating-notifications {
        background: transparent;
    }

    .floating-notifications .notification {
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.4);
    }
  '';
}
