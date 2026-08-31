{ config, pkgs, lib, ... }:

let
  # Rose Pine — mirrors the palette in noctalia.nix so the lock screen and the
  # shell agree on colour without either importing the other.
  base = "191724";
  overlay = "26233a";
  text = "e0def4";
  subtle = "908caa";
  muted = "6e6a86";
  iris = "c4a7e7";
  rose = "ebbcba";
  gold = "f6c177";
  love = "eb6f92";

  wallpaper = "${config.home.homeDirectory}/wallpapers/wallpaper.png";
in
{
  # Hyprlock — the riced lock screen.
  #
  # Composition is deliberately offset to the lower left: the artwork is a
  # centred silhouette under a blown-out light column, which is exactly where a
  # centred clock and password field would sit. Anchoring the widgets bottom-left
  # keeps the subject and its light column completely uncovered, and the corner
  # is already near-black in the art so the text needs no scrim behind it.
  #
  # Blur is kept low for the same reason — with nothing overlapping the subject
  # there is no legibility problem to solve, so the art stays readable.
  xdg.configFile."hypr/hyprlock.conf".text = ''
    general {
        hide_cursor = true
        grace = 2
        ignore_empty_input = true
        immediate_render = true
    }

    animations {
        enabled = true
        bezier = smooth, 0.25, 0.1, 0.25, 1.0
        animation = fade, 1, 5, smooth
        animation = inputFieldDots, 1, 2, smooth
    }

    background {
        monitor =
        path = ${wallpaper}
        # Light touch: the widgets never overlap the subject, so the art keeps
        # its contrast instead of being blurred into a backdrop.
        blur_passes = 1
        blur_size = 3
        noise = 0.008
        contrast = 1.05
        brightness = 0.75
        vibrancy = 0.15
        vibrancy_darkness = 0.05
        color = rgba(${base}ff)
    }

    # Vertical accent rule anchoring the text cluster to the left edge.
    shape {
        monitor =
        size = 3, 260
        color = rgba(${iris}cc)
        rounding = 2
        border_size = 0
        position = 64, 96
        halign = left
        valign = bottom
    }

    # ── Text cluster, bottom left ──

    label {
        monitor =
        text = $TIME
        color = rgba(${text}ff)
        font_size = 96
        font_family = Iosevka NFM
        position = 100, 268
        halign = left
        valign = bottom
    }

    label {
        monitor =
        text = cmd[update:60000] date +"%A, %-d %B"
        color = rgba(${rose}ff)
        font_size = 20
        font_family = Iosevka NFM
        position = 104, 232
        halign = left
        valign = bottom
    }

    label {
        monitor =
        text = <span foreground="##${muted}">locked as</span> <span foreground="##${subtle}">$USER</span>
        color = rgba(${subtle}ff)
        font_size = 14
        font_family = Iosevka NFM
        position = 104, 200
        halign = left
        valign = bottom
    }

    input-field {
        monitor =
        size = 320, 50
        outline_thickness = 2
        rounding = 12
        dots_size = 0.24
        dots_spacing = 0.3
        dots_center = true
        outer_color = rgba(${iris}ff)
        inner_color = rgba(${overlay}cc)
        font_color = rgba(${text}ff)
        check_color = rgba(${gold}ff)
        fail_color = rgba(${love}ff)
        capslock_color = rgba(${gold}ff)
        fail_text = <span foreground="##${love}">$FAIL</span>
        fail_transition = 300
        placeholder_text = <span foreground="##${muted}">enter password</span>
        fade_on_empty = false
        position = 100, 112
        halign = left
        valign = bottom
    }

    # ── Status, bottom right ──

    label {
        monitor =
        text = cmd[update:60000] uptime -p | sed 's/^up /󰅐  /'
        color = rgba(${muted}ff)
        font_size = 13
        font_family = Iosevka NFM
        position = -64, 100
        halign = right
        valign = bottom
    }

    label {
        monitor =
        text = cmd[update:0] echo "󰌾  $(hostname)"
        color = rgba(${muted}ff)
        font_size = 13
        font_family = Iosevka NFM
        position = -64, 74
        halign = right
        valign = bottom
    }
  '';

  # Hypridle — owns idle and the logind lock signal, so `loginctl lock-session`
  # (SUPER+SHIFT+X) and lid/sleep events all route to the same locker.
  #
  # No brightnessctl dim step: this machine drives two DisplayPort monitors with
  # no backlight device, so the old dim listener was a no-op. Displays go
  # straight from locked to DPMS off.
  xdg.configFile."hypr/hypridle.conf".text = ''
    general {
        lock_cmd = pidof hyprlock || hyprlock
        before_sleep_cmd = loginctl lock-session
        after_sleep_cmd = hyprctl dispatch dpms on
        ignore_dbus_inhibit = false
        ignore_systemd_inhibit = false
    }

    # Lock after 10 minutes idle.
    listener {
        timeout = 600
        on-timeout = loginctl lock-session
    }

    # Blank the displays 5 minutes after locking.
    listener {
        timeout = 900
        on-timeout = hyprctl dispatch dpms off
        on-resume = hyprctl dispatch dpms on
    }
  '';
}
