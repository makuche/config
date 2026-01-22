{pkgs, ...}: let
  defaultBrowser = "com.brave.Browser";
in {
  # common system config (git provided by xcode-select --install)
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
  nix.enable = false;
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
  # Enable Touch ID for sudo
  security.pam.services.sudo_local.touchIdAuth = true;
}
