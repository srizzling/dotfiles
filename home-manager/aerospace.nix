{ config, pkgs, lib, ... }:

{
  # Configure AeroSpace window manager
  xdg.configFile."aerospace/aerospace.toml".text = ''
    # Place a copy of this config to ~/.config/aerospace/aerospace.toml
    # After that, you can edit ~/.config/aerospace/aerospace.toml to your liking

    # Feel free to omit keys that match the default value
    # https://github.com/nikitabobko/AeroSpace/blob/main/docs/config-reference.md

    # You can use it to add commands that run after login to macOS user session.
    # 'start-at-login' needs to be 'true' for 'after-login-command' to work
    # Available commands: https://github.com/nikitabobko/AeroSpace/blob/main/docs/commands.md
    start-at-login = true

    # Notify Dock "hide application" (cmd-h) command to hide as many windows as possible, instead of hiding the application.
    enable-normalization-flatten-containers = true
    enable-normalization-opposite-orientation-for-nested-containers = true

    # See: https://github.com/nikitabobko/AeroSpace/blob/main/docs/config-reference.md#layout
    default-root-container-layout = 'tiles'

    # Mouse follows focus when focused window changes
    # drop it from your config, if you don't like it
    on-focused-monitor-changed = ['move-mouse monitor-lazy-center']

    # Gaps between windows (inner-*) and between monitor edges and windows (outer-*)
    [gaps]
    inner.horizontal = 10
    inner.vertical = 10
    outer.left = 40
    outer.bottom = 40
    outer.top = 40
    outer.right = 40

    # 'main' binding mode is always active
    [mode.main.binding]

    # All possible keys:
    # - Letters.        a, b, c, ..., z
    # - Numbers.        0, 1, 2, ..., 9
    # - Keypad numbers. keypad0, keypad1, keypad2, ..., keypad9
    # - F-keys.         f1, f2, ..., f20
    # - Special keys.   minus, equal, period, comma, slash, backslash, quote, semicolon, backtick,
    #                   leftSquareBracket, rightSquareBracket, space, enter, esc, backspace, tab
    # - Keypad special. keypadClear, keypadDecimalMark, keypadDivide, keypadEnter, keypadEqual,
    #                   keypadMinus, keypadMultiply, keypadPlus
    # - Arrows.         left, down, up, right

    # All possible modifiers: cmd, alt, ctrl, shift

    # All possible commands: https://github.com/nikitabobko/AeroSpace/blob/main/docs/commands.md

    # See: https://github.com/nikitabobko/AeroSpace/blob/main/docs/commands.md#focus
    alt-h = 'focus left'
    alt-j = 'focus down'
    alt-k = 'focus up'
    alt-l = 'focus right'

    # See: https://github.com/nikitabobko/AeroSpace/blob/main/docs/commands.md#move
    alt-shift-h = 'move left'
    alt-shift-j = 'move down'
    alt-shift-k = 'move up'
    alt-shift-l = 'move right'

    # See: https://github.com/nikitabobko/AeroSpace/blob/main/docs/commands.md#resize
    alt-shift-minus = 'resize smart -50'
    alt-shift-equal = 'resize smart +50'

    # See: https://github.com/nikitabobko/AeroSpace/blob/main/docs/commands.md#workspace
    alt-1 = 'workspace 1'
    alt-2 = 'workspace 2'
    alt-b = 'workspace B'  # Browser
    alt-c = 'workspace C'  # Code
    alt-e = 'workspace E'  # Email
    alt-m = 'workspace M'  # Music
    alt-n = 'workspace N'  # Notes
    alt-s = 'workspace S'  # Social
    alt-t = 'workspace T'  # Terminal

    # See: https://github.com/nikitabobko/AeroSpace/blob/main/docs/commands.md#move-node-to-workspace
    alt-shift-1 = 'move-node-to-workspace 1'
    alt-shift-2 = 'move-node-to-workspace 2'
    alt-shift-b = 'move-node-to-workspace B'
    alt-shift-c = 'move-node-to-workspace C'
    alt-shift-e = 'move-node-to-workspace E'
    alt-shift-m = 'move-node-to-workspace M'
    alt-shift-n = 'move-node-to-workspace N'
    alt-shift-s = 'move-node-to-workspace S'
    alt-shift-t = 'move-node-to-workspace T'

    # Navigate between monitors with arrow keys
    alt-left = 'focus-monitor left'
    alt-right = 'focus-monitor right'

    # Move current window between monitors with shift + arrow keys
    alt-shift-left = 'move-node-to-monitor left'
    alt-shift-right = 'move-node-to-monitor right'

    # Navigate between workspaces with up/down arrows
    alt-up = 'workspace --wrap-around prev'
    alt-down = 'workspace --wrap-around next'

    # Move windows between workspaces with shift + up/down arrows
    alt-shift-up = 'move-node-to-workspace --wrap-around prev'
    alt-shift-down = 'move-node-to-workspace --wrap-around next'

    # See: https://github.com/nikitabobko/AeroSpace/blob/main/docs/commands.md#workspace-back-and-forth
    alt-tab = 'workspace-back-and-forth'
    # See: https://github.com/nikitabobko/AeroSpace/blob/main/docs/commands.md#move-workspace-to-monitor
    alt-shift-tab = 'move-workspace-to-monitor --wrap-around next'

    # See: https://github.com/nikitabobko/AeroSpace/blob/main/docs/commands.md#mode
    alt-shift-semicolon = 'mode service'

    # 'service' binding mode declaration.
    # See: https://github.com/nikitabobko/AeroSpace/blob/main/docs/guide.md#binding-modes
    [mode.service.binding]
    esc = ['reload-config', 'mode main']
    r = ['flatten-workspace-tree', 'mode main'] # reset layout
    f = ['layout floating tiling', 'mode main'] # Toggle between floating and tiling layout
    backspace = ['close-all-windows-but-current', 'mode main']

    alt-shift-h = ['join-with left', 'mode main']
    alt-shift-j = ['join-with down', 'mode main']
    alt-shift-k = ['join-with up', 'mode main']
    alt-shift-l = ['join-with right', 'mode main']

    # Assign applications to workspaces
    # See: https://github.com/nikitabobko/AeroSpace/blob/main/docs/guide.md#assign-workspaces-to-monitors

    [[on-window-detected]]
    if.app-id = 'com.microsoft.VSCode'
    run = 'move-node-to-workspace C'

    [[on-window-detected]]
    if.app-id = 'com.google.Chrome'
    run = 'move-node-to-workspace B'

    [[on-window-detected]]
    if.app-id = 'org.mozilla.firefox'
    run = 'move-node-to-workspace B'

    [[on-window-detected]]
    if.app-id = 'com.apple.Safari'
    run = 'move-node-to-workspace B'

    [[on-window-detected]]
    if.app-id = 'com.spotify.client'
    run = 'move-node-to-workspace M'

    [[on-window-detected]]
    if.app-id = 'com.tinyspeck.slackmacgui'
    run = 'move-node-to-workspace S'

    [[on-window-detected]]
    if.app-id = 'com.microsoft.teams2'
    run = 'move-node-to-workspace S'

    [[on-window-detected]]
    if.app-id = 'discord.Discord'
    run = 'move-node-to-workspace S'

    [[on-window-detected]]
    if.app-id = 'com.googlecode.iterm2'
    run = 'move-node-to-workspace T'

    [[on-window-detected]]
    if.app-id = 'com.mitchell.ghostty'
    run = 'move-node-to-workspace T'
  '';

  # Automatically reload AeroSpace configuration when it changes
  home.activation.reloadAerospace = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if command -v aerospace >/dev/null 2>&1; then
      echo "Reloading AeroSpace configuration..."
      $DRY_RUN_CMD aerospace reload-config
    fi
  '';
}