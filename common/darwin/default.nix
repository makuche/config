{pkgs, ...}: {
  # common system config
  environment.systemPackages = with pkgs; [
    # TODO: install via xcode-select
    # check:
    # https://github.com/dustinlyons/nixos-config?tab=readme-ov-file#for-macos-november-2025
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
  nix.gc = {
    automatic = true;
    interval = { Weekday = 0; Hour = 0; Minute = 0; };
    options = "--delete-older-than 7d";
  };


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
    # disable animation system-wide
    universalaccess.reduceMotion = true;
  };

  fonts.packages = with pkgs; [
    nerd-fonts.mononoki
  ];
  # Enable Touch ID for sudo
  security.pam.services.sudo_local.touchIdAuth = true;
}
