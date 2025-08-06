{ config, pkgs, lib, ... }:

{
  # GUI packages that are available in nixpkgs
  environment.systemPackages = with pkgs; [
    # Fonts
    (nerdfonts.override { fonts = [ "Iosevka" ]; })
    
    # Terminal utilities that might have GUI components
    # (Most GUI apps are managed via Homebrew in darwin-base.nix)
  ];

  # Font configuration
  fonts.fontDir.enable = true;
  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "Iosevka" ]; })
  ];
}