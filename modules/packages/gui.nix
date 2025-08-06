{ config, pkgs, lib, ... }:

{
  # GUI packages that are available in nixpkgs
  environment.systemPackages = with pkgs; [
    # Terminal utilities that might have GUI components
    # (Most GUI apps are managed via Homebrew in darwin-base.nix)
  ];

  # Font configuration (updated for current nix-darwin)
  fonts.packages = with pkgs; [
    nerd-fonts.iosevka
  ];
}