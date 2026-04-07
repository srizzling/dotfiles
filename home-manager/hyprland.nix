{ config, pkgs, lib, ... }:

{
  # Hyprland window manager configuration
  # Mirrors aerospace keybindings and workspace layout
  # Hyprlock — GPU-accelerated lock screen, Rose Pine themed
  xdg.configFile."hypr/hyprlock.conf".text = ''
    general {
        hide_cursor = true
        grace = 3
    }

    background {
        monitor =
        path = screenshot
        blur_passes = 4
        blur_size = 8
        noise = 0.02
        contrast = 0.8
        brightness = 0.6
        vibrancy = 0.2
        color = rgba(191724ff)
    }

    input-field {
        monitor =
        size = 300, 50
        outline_thickness = 2
        dots_size = 0.25
        dots_spacing = 0.15
        dots_center = true
        outer_color = rgba(c4a7e7ff)
        inner_color = rgba(26233aff)
        font_color = rgba(e0def4ff)
        fade_on_empty = true
        fade_timeout = 2000
        placeholder_text = <span foreground="##908caa">...</span>
        fail_color = rgba(eb6f92ff)
        fail_text = <span foreground="##eb6f92">$FAIL</span>
        fail_transition = 300
        capslock_color = rgba(f6c177ff)
        position = 0, -80
        halign = center
        valign = center
        rounding = 12
    }

    label {
        monitor =
        text = $TIME
        color = rgba(e0def4ff)
        font_size = 90
        font_family = Iosevka NFM
        position = 0, 80
        halign = center
        valign = center
    }

    label {
        monitor =
        text = Hi, $USER
        color = rgba(ebbcbaff)
        font_size = 18
        font_family = Iosevka NFM
        position = 0, 20
        halign = center
        valign = center
    }
  '';

  # Hypridle — idle daemon, dims then locks then sleeps
  xdg.configFile."hypr/hypridle.conf".text = ''
    general {
        lock_cmd = pidof hyprlock || hyprlock
        before_sleep_cmd = loginctl lock-session
        after_sleep_cmd = hyprctl dispatch dpms on
    }

    # Dim screen after 5 minutes
    listener {
        timeout = 300
        on-timeout = brightnessctl -s set 30
        on-resume = brightnessctl -r
    }

    # Lock after 10 minutes
    listener {
        timeout = 600
        on-timeout = loginctl lock-session
    }

    # Turn off displays after 15 minutes
    listener {
        timeout = 900
        on-timeout = hyprctl dispatch dpms off
        on-resume = hyprctl dispatch dpms on
    }
  '';

  xdg.configFile."hypr/hyprland.conf".text = ''
    ################
    ### MONITORS ###
    ################

    # XB270HU (1440p 144Hz) on the LEFT
    monitor = DP-2, 2560x1440@144, 0x0, 1

    # MPG 274U E16M (4K 160Hz) on the RIGHT
    monitor = DP-1, 3840x2160@160, 2560x0, 1.5

    # Fallback for any other monitors
    monitor = , preferred, auto, auto


    ###################
    ### MY PROGRAMS ###
    ###################

    $terminal = ghostty
    $menu = fuzzel
    $mainMod = SUPER


    #############################
    ### ENVIRONMENT VARIABLES ###
    #############################

    env = XCURSOR_SIZE,24
    env = HYPRCURSOR_SIZE,24
    env = HYPRCURSOR_THEME,rose-pine-hyprcursor
    env = XDG_CURRENT_DESKTOP,Hyprland
    env = XDG_SESSION_TYPE,wayland
    env = XDG_SESSION_DESKTOP,Hyprland
    env = GDK_DPI_SCALE,1


    #################
    ### AUTOSTART ###
    #################

    exec-once = waybar
    exec-once = dunst
    exec-once = hypridle
    exec-once = awww-daemon
    exec = awww img ~/wallpapers/wallpaper.png --transition-type grow --transition-pos center --transition-duration 1


    #####################
    ### LOOK AND FEEL ###
    #####################

    general {
        gaps_in = 4
        gaps_out = 8
        border_size = 0

        resize_on_border = true
        allow_tearing = true
        layout = dwindle
    }

    decoration {
        rounding = 8

        active_opacity = 1.0
        inactive_opacity = 0.9

        shadow {
            enabled = true
            range = 20
            render_power = 4
            color = rgba(0a0814cc)
            offset = 0 2
        }

        blur {
            enabled = true
            size = 8
            passes = 4
            new_optimizations = true
            vibrancy = 0.4
            vibrancy_darkness = 0.6
            noise = 0.015
            contrast = 0.9
            brightness = 0.75
            popups = true
            special = true
        }

        dim_inactive = true
        dim_strength = 0.12
    }

    animations {
        enabled = true

        # Single smooth bezier — snappy with slight overshoot
        bezier = smooth, 0.05, 0.9, 0.1, 1.05
        bezier = liner, 1, 1, 1, 1

        # Windows pop in, fade out
        animation = windows, 1, 5, smooth, popin 80%
        animation = windowsIn, 1, 5, smooth, popin 80%
        animation = windowsOut, 1, 4, smooth, popin 80%
        animation = windowsMove, 1, 4, smooth, slide

        # Border
        animation = border, 1, 10, liner

        # Fade — smooth and quick
        animation = fade, 1, 4, smooth
        animation = fadeIn, 1, 4, smooth
        animation = fadeOut, 1, 3, smooth

        # Workspaces — horizontal slide
        animation = workspaces, 1, 4, smooth, slide

        # Layers (waybar, fuzzel, dunst) — fade only, no slide
        animation = layers, 1, 4, smooth, fade
        animation = layersIn, 1, 4, smooth, fade
        animation = layersOut, 1, 3, smooth, fade
        animation = fadeLayersIn, 1, 3, smooth
        animation = fadeLayersOut, 1, 3, smooth
    }

    dwindle {
        pseudotile = true
        preserve_split = true
    }

    misc {
        vrr = 0
        force_default_wallpaper = 0
        disable_hyprland_logo = true
        mouse_move_focuses_monitor = true
    }

    render {
        direct_scanout = true
    }


    #############
    ### INPUT ###
    #############

    input {
        kb_layout = us
        follow_mouse = 1
        sensitivity = 0
    }


    ##################################
    ### KEYBINDINGS (aerospace-like) #
    ##################################

    # ── Launch ──
    bind = $mainMod, Return, exec, $terminal
    bind = $mainMod, space, exec, fuzzel
    bind = $mainMod, Q, killactive,
    bind = $mainMod SHIFT, Q, exit,
    bind = $mainMod, F, fullscreen, 0
    bind = $mainMod SHIFT, X, exec, hyprlock
    bind = $mainMod SHIFT, Return, exec, firefox

    # ── Focus (vim-style, matching aerospace alt-h/j/k/l) ──
    bind = $mainMod, H, movefocus, l
    bind = $mainMod, J, movefocus, d
    bind = $mainMod, K, movefocus, u
    bind = $mainMod, L, movefocus, r

    # ── Move windows (matching aerospace alt-shift-h/j/k/l) ──
    bind = $mainMod SHIFT, H, movewindow, l
    bind = $mainMod SHIFT, J, movewindow, d
    bind = $mainMod SHIFT, K, movewindow, u
    bind = $mainMod SHIFT, L, movewindow, r

    # ── Resize (matching aerospace alt-shift-minus/equal) ──
    bind = $mainMod SHIFT, minus, resizeactive, -50 0
    bind = $mainMod SHIFT, equal, resizeactive, 50 0

    # ── Named workspaces (matching aerospace alt-letter) ──
    bind = $mainMod, 1, workspace, name:1
    bind = $mainMod, 2, workspace, name:2
    bind = $mainMod, B, workspace, name:B
    bind = $mainMod, C, workspace, name:C
    bind = $mainMod, E, workspace, name:E
    bind = $mainMod, M, workspace, name:M
    bind = $mainMod, N, workspace, name:N
    bind = $mainMod, G, workspace, name:G
    bind = $mainMod, S, workspace, name:S
    bind = $mainMod, T, workspace, name:T

    # ── Move to workspace (matching aerospace alt-shift-letter) ──
    bind = $mainMod SHIFT, 1, movetoworkspace, name:1
    bind = $mainMod SHIFT, 2, movetoworkspace, name:2
    bind = $mainMod SHIFT, B, movetoworkspace, name:B
    bind = $mainMod SHIFT, C, movetoworkspace, name:C
    bind = $mainMod SHIFT, E, movetoworkspace, name:E
    bind = $mainMod SHIFT, M, movetoworkspace, name:M
    bind = $mainMod SHIFT, N, movetoworkspace, name:N
    bind = $mainMod SHIFT, G, movetoworkspace, name:G
    bind = $mainMod SHIFT, S, movetoworkspace, name:S
    bind = $mainMod SHIFT, T, movetoworkspace, name:T

    # ── Monitor navigation (matching aerospace alt-left/right) ──
    bind = $mainMod, left, focusmonitor, l
    bind = $mainMod, right, focusmonitor, r

    # ── Move windows between monitors (matching aerospace alt-shift-left/right) ──
    bind = $mainMod SHIFT, left, movewindow, mon:l
    bind = $mainMod SHIFT, right, movewindow, mon:r

    # ── Workspace cycling (matching aerospace alt-up/down) ──
    bind = $mainMod, up, workspace, m-1
    bind = $mainMod, down, workspace, m+1
    bind = $mainMod SHIFT, up, movetoworkspace, m-1
    bind = $mainMod SHIFT, down, movetoworkspace, m+1

    # ── Workspace back-and-forth (matching aerospace alt-tab) ──
    bind = $mainMod, Tab, workspace, previous

    # ── Move workspace to monitor (matching aerospace alt-shift-tab) ──
    bind = $mainMod SHIFT, Tab, movecurrentworkspacetomonitor, +1

    # ── Toggle floating ──
    bind = $mainMod, V, togglefloating,

    # ── Mouse bindings ──
    bindm = $mainMod, mouse:272, movewindow
    bindm = $mainMod, mouse:273, resizewindow

    # ── Media keys ──
    bindel = , XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+
    bindel = , XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
    bindel = , XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    bindl = , XF86AudioNext, exec, playerctl next
    bindl = , XF86AudioPause, exec, playerctl play-pause
    bindl = , XF86AudioPlay, exec, playerctl play-pause
    bindl = , XF86AudioPrev, exec, playerctl previous

    # ── Service submap (matching aerospace service mode) ──
    bind = $mainMod SHIFT, semicolon, submap, service

    submap = service

    # Reload config and exit submap
    bind = , escape, exec, hyprctl reload
    bind = , escape, submap, reset

    # Reset layout
    bind = , R, exec, hyprctl dispatch layoutmsg removemaster
    bind = , R, submap, reset

    # Toggle float
    bind = , F, togglefloating,
    bind = , F, submap, reset

    submap = reset


    ##########################################
    ### WORKSPACE-TO-MONITOR ASSIGNMENTS ###
    ##########################################

    # Secondary monitor (XB270HU = DP-2 = LEFT)
    workspace = name:1, monitor:DP-2, default:true
    workspace = name:S, monitor:DP-2
    workspace = name:M, monitor:DP-2
    workspace = name:E, monitor:DP-2
    workspace = name:N, monitor:DP-2

    # Primary monitor (MPG 274U = DP-1 = RIGHT)
    workspace = name:2, monitor:DP-1, default:true
    workspace = name:B, monitor:DP-1
    workspace = name:C, monitor:DP-1
    workspace = name:T, monitor:DP-1
    workspace = name:G, monitor:DP-1


    ##########################
    ### WINDOW RULES ###
    ##########################

    # ── Browser → B ──
    windowrule {
        name = browser-to-b
        match:class = ^(firefox|google-chrome)$
        workspace = name:B
    }

    # ── Code → C ──
    windowrule {
        name = code-to-c
        match:class = ^(code|Code)$
        workspace = name:C
    }

    # ── Music → M ──
    windowrule {
        name = music-to-m
        match:class = ^(Spotify|spotify)$
        workspace = name:M
    }

    # ── Social → S ──
    windowrule {
        name = social-to-s
        match:class = ^(vesktop|WebCord|discord|zapzap|ZapZap)$
        workspace = name:S
    }

    # ── Terminal → T ──
    windowrule {
        name = terminal-to-t
        match:class = ^(kitty|com.mitchellh.ghostty)$
        workspace = name:T
    }

    # ── Video → N (Notes/Media) ──
    windowrule {
        name = video-to-n
        match:class = ^(FreeTube|freetube)$
        workspace = name:N
    }

    # ── Gaming → G (floating) ──
    windowrule {
        name = steam-to-g
        match:class = ^(steam)$
        workspace = name:G
        float = true
    }

    windowrule {
        name = gamescope-to-g
        match:class = ^(gamescope)$
        workspace = name:G
    }

    windowrule {
        name = lutris-to-g
        match:class = ^(lutris)$
        workspace = name:G
        float = true
    }

    windowrule {
        name = league-to-g
        match:title = ^(.*League of Legends.*)$
        workspace = name:G
        float = true
    }

    # ── Gaming: allow tearing for fullscreen games ──
    windowrule {
        name = game-tearing
        match:class = ^(steam_app_.*)$
        immediate = true
    }

    # ── Calendar popup ──
    windowrule {
        name = calendar-popup
        match:title = ^(calendar)$
        float = true
        pin = true
        size = 340 360
    }

    # ── General rules ──
    windowrule {
        name = suppress-maximize-events
        match:class = .*
        suppress_event = maximize
    }
  '';
}
