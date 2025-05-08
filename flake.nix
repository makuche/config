# System configuration file for my macOS system, handling
# - Installaion of system packages (nixpkgs and nix-darwin)
# - Define user environments configs, dotfiles etc. (home-manager)
# - Integrates Homebrew for macOS specific software (nix-homebrew)
{
  description = "System flake configuration file for multiple machines";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # user environments via home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # macOS config via nix-darwin
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # homebrew integration
    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
  };
  # Output/State that will be created
  outputs = inputs @ {
    self,
    nix-darwin,
    home-manager,
    nix-homebrew,
    homebrew-core,
    homebrew-cask,
    ...
  }: {
    # VM configuration
    darwinConfigurations."MKs-Virtual-Machine" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        ./common/darwin/default.nix
        ./hosts/vm/configuration.nix

        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.manuel = import ./hosts/vm/home.nix;
        }

        # Homebrew integration
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            enableRosetta = true;
            user = "smc";
            taps = {
              "homebrew/homebrew-core" = homebrew-core;
              "homebrew/homebrew-cask" = homebrew-cask;
            };
            mutableTaps = false;
          };
        }
      ];
    };

    # MacBook configuration
    darwinConfigurations."Manuels-MacBook-Pro" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        ./common/darwin/default.nix
        ./hosts/macbook/configuration.nix

        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.manuel = import ./hosts/macbook/home.nix;
        }

        # Homebrew integration
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            enableRosetta = true;
            user = "manuel";
            taps = {
              "homebrew/homebrew-core" = homebrew-core;
              "homebrew/homebrew-cask" = homebrew-cask;
            };
            mutableTaps = false;
          };
        }
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = {
      "MKs-Virtual-Machine" = self.darwinConfigurations."MKs-Virtual-Machine".pkgs;
      "Manuels-MacBook-Pro" = self.darwinConfigurations."Manuels-MacBook-Pro".pkgs;
    };
  };
}
