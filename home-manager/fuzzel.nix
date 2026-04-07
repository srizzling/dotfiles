{ config, pkgs, lib, ... }:

{
  # Fuzzel application launcher — Rose Pine, glass-morphism
  xdg.configFile."fuzzel/fuzzel.ini".text = ''
    [main]
    font=Iosevka NFM:size=13
    dpi-aware=auto
    width=50
    lines=12
    prompt="  "
    icon-theme=Papirus-Dark
    layer=overlay
    horizontal-pad=16
    vertical-pad=10
    inner-pad=8

    [colors]
    background=191724dd
    text=e0def4ff
    match=c4a7e7ff
    selection=26233aff
    selection-text=e0def4ff
    selection-match=ebbcbaff
    border=403d5266

    [border]
    width=1
    radius=8
  '';
}
