{
  description = "srizzling's macOS dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    brew-nix = {
      url = "github:BatteredBunny/brew-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix";
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, brew-nix, catppuccin, ... }:
  let
    system = "aarch64-darwin";

    mkDarwinSystem = hostName: profile: username: nix-darwin.lib.darwinSystem {
      inherit system;
      specialArgs = { inherit profile system; };
      modules = [
        ./darwin
        # Add brew-nix module
        brew-nix.darwinModules.default
        ({pkgs, ...}: {
          # Enable brew-nix
          brew-nix.enable = true;

          # Add system-level packages (prefer nixpkgs, fallback to brew-nix)
          environment.systemPackages = with pkgs; [
            # Terminal emulator - using brew-nix due to build issues in nixpkgs
            brewCasks.ghostty
            # OrbStack for container management
            brewCasks.orbstack
          ];
        })
        # Re-enable home-manager with explicit Darwin configuration  
        home-manager.darwinModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "backup";  # Backup existing files
            extraSpecialArgs = { inherit profile; };
            users.${username} = { pkgs, lib, ... }: {
              imports = [ 
                ./home-manager 
                catppuccin.homeModules.catppuccin
              ];
              # Explicitly set homeDirectory for Darwin, forcing override
              home.homeDirectory = lib.mkForce "/Users/${username}";
              home.username = lib.mkForce username;
            };
          };
        }
      ];
    };
  in
  {
    # Apple Silicon configurations
    darwinConfigurations = {
      "personal" = mkDarwinSystem "personal" "personal" "srizzling";
      "work" = mkDarwinSystem "work" "work" "srizzling";
    };

    # Development shell
    devShells.aarch64-darwin.default = nixpkgs.legacyPackages.aarch64-darwin.mkShell {
      buildInputs = with nixpkgs.legacyPackages.aarch64-darwin; [ gnumake ];
    };
  };
}