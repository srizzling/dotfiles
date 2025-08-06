{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ../modules/system/darwin-base.nix
    ../modules/packages/development.nix
    ../modules/packages/gui.nix
  ];

  # System configuration
  system.stateVersion = 4;
  
  # Host-specific settings
  networking.hostName = "personal-mac";
  
  # Personal git identity
  users.users.srizzling = {
    name = "srizzling";
    home = "/Users/srizzling";
  };

  # Override home-manager git config for personal use
  home-manager.users.srizzling = {
    programs.git = {
      userName = lib.mkForce "Your Personal Name";
      userEmail = lib.mkForce "personal@email.com";
    };
  };
}