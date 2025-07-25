{pkgs, ...}: {
  # common system config
  environment.systemPackages = with pkgs; [
    git # for bootstrapping the system
  ];

  homebrew = {
    enable = true;
    global.autoUpdate = true;
    global.brewfile = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };
    caskArgs = {
      require_sha = true;
    };
  };

  nix.settings.experimental-features = "nix-command flakes";
  nix.enable = true;

  system.stateVersion = 5;

  # common platform configuration
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true; # required for terraform installation
  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;

  # common system defaults
  system.defaults = {
    NSGlobalDomain = {
      "com.apple.swipescrolldirection" = false;
      "InitialKeyRepeat" = 10;
      "KeyRepeat" = 1;
      "NSAutomaticWindowAnimationsEnabled" = false; # disable animations
    };
    dock = {
      "launchanim" = false;
    };
  };

  fonts.packages = with pkgs; [
    nerd-fonts.mononoki
  ];
}
