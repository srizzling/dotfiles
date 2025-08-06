{
  description = "Personal dotfiles managed with Nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, darwin, home-manager, ... } @ inputs: {
    # Darwin configurations
    darwinConfigurations = {
      # Personal machine configuration
      "personal" = darwin.lib.darwinSystem {
        system = "aarch64-darwin";  # Apple Silicon
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/darwin-personal.nix
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.srizzling = import ./home/home.nix;
              extraSpecialArgs = { inherit inputs; };
            };
          }
        ];
      };

      # Work machine configuration (can be customized separately)
      "work" = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/darwin-work.nix
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.srizzling = import ./home/home.nix;
              extraSpecialArgs = { inherit inputs; };
            };
          }
        ];
      };
    };

    # Development shells
    devShells = let
      systems = [ "aarch64-darwin" "x86_64-darwin" "x86_64-linux" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f {
        pkgs = import nixpkgs { inherit system; };
      });
    in forAllSystems ({ pkgs }: {
      default = pkgs.mkShell {
        buildInputs = with pkgs; [
          # Tools for managing this flake
          nil  # Nix LSP
          nixpkgs-fmt
        ];
      };
    });

    # Phase completion tests
    checks = let
      systems = [ "aarch64-darwin" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f {
        pkgs = import nixpkgs { inherit system; };
      });
    in forAllSystems ({ pkgs }: 
      import ./checks/phase1.nix { inherit pkgs; lib = nixpkgs.lib; }
    );
  };
}