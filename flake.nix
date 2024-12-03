{
  description = "System flake configuration file";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew = { url = "github:zhaofengli-wip/nix-homebrew"; };

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

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, nix-homebrew
    , homebrew-core, homebrew-cask, homebrew-bundle, ... }: {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#MacBook-Pro
      darwinConfigurations."Manuels-MacBook-Pro" =
        nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            /Users/manuel/.config/nix-darwin/configuration.nix

            home-manager.darwinModules.home-manager
            {
              # `home-manager` config
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.manuel = import ./home-manager/home.nix;
            }

            nix-homebrew.darwinModules.nix-homebrew
            {
              nix-homebrew = {
                enable = true;
                # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
                enableRosetta = true;
                user = "manuel";

                taps = {
                  "homebrew/homebrew-core" = homebrew-core;
                  "homebrew/homebrew-cask" = homebrew-cask;
                  "homebrew/homebrew-bundle" = homebrew-bundle;
                };
                mutableTaps = false;
              };
            }

          ];
        };

      # Expose the package set, including overlays, for convenience.
      darwinPackages =
        self.darwinConfigurations."Manuels-MacBook-Pro".pkgs;
    };
}
