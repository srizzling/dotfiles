{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ../modules/system/darwin-base.nix
    ../modules/packages/development.nix
    ../modules/packages/gui.nix
  ];

  # System configuration
  system.stateVersion = 4;
  system.primaryUser = "srizzling";
  
  # Host-specific settings
  networking.hostName = "work-mac";
  
  # Work-specific settings can be added here
  users.users.srizzling = {
    name = "srizzling";
    home = "/Users/srizzling";
  };

  # Override home-manager git config for work use
  home-manager.users.srizzling = {
    programs.git = {
      userName = lib.mkForce "Your Work Name";
      userEmail = lib.mkForce "work@company.com";
    };
  };
}