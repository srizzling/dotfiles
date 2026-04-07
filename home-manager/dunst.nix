{ config, pkgs, lib, ... }:

{
  # Dunst notifications — Rose Pine, matches tight borderless aesthetic
  xdg.configFile."dunst/dunstrc".text = ''
    [global]
    width = (280, 360)
    height = 100
    offset = 8x44
    origin = top-right
    notification_limit = 4
    transparency = 0
    frame_width = 0
    font = Iosevka NFM 11
    corner_radius = 8
    separator_height = 2
    separator_color = "#26233a"
    padding = 14
    horizontal_padding = 16
    text_icon_padding = 12
    icon_position = left
    min_icon_size = 32
    max_icon_size = 48
    gap_size = 4
    highlight = "#c4a7e7"
    progress_bar = true
    progress_bar_height = 6
    progress_bar_frame_width = 0
    progress_bar_min_width = 150
    progress_bar_max_width = 300
    progress_bar_corner_radius = 3
    alignment = left
    vertical_alignment = center
    show_age_threshold = 30
    ellipsize = end
    markup = full
    format = "<b>%s</b>\n%b"
    sort = yes
    idle_threshold = 120
    show_indicators = no
    mouse_left_click = close_current
    mouse_middle_click = close_all
    mouse_right_click = do_action

    [urgency_low]
    background = "#1f1d2e"
    foreground = "#908caa"
    timeout = 4

    [urgency_normal]
    background = "#1f1d2e"
    foreground = "#e0def4"
    highlight = "#c4a7e7"
    timeout = 6

    [urgency_critical]
    background = "#1f1d2e"
    foreground = "#eb6f92"
    highlight = "#eb6f92"
    timeout = 0
  '';
}
