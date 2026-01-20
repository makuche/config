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
    nikitabobko-tap = {
      url = "github:nikitabobko/homebrew-tap";
      flake = false;
    };
  };
  outputs = inputs @ {
    self,
    nix-darwin,
    home-manager,
    nix-homebrew,
    homebrew-core,
    homebrew-cask,
    nikitabobko-tap,
    ...
  }: {
    # atlas - primary macOS machine
    darwinConfigurations."atlas" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        ./common/darwin/default.nix
        ./hosts/atlas/configuration.nix

        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.manuel = import ./hosts/atlas/home.nix;
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
              "nikitabobko/homebrew-tap" = nikitabobko-tap;
            };
            mutableTaps = false;
          };
        }
      ];
    };

    # cosmos - secondary macOS machine
    darwinConfigurations."cosmos" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        ./common/darwin/default.nix
        ./hosts/cosmos/configuration.nix

        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.manuel = import ./hosts/cosmos/home.nix;
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
              "nikitabobko/homebrew-tap" = nikitabobko-tap;
            };
            mutableTaps = false;
          };
        }
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = {
      "atlas" = self.darwinConfigurations."atlas".pkgs;
      "cosmos" = self.darwinConfigurations."cosmos".pkgs;
    };
  };
}
