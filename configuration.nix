{pkgs, ...}: {
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
      appdir = "/Applications/";
      require_sha = true;
    };
    brews = [
      "llama.cpp"
      "kubectl"
      "k9s"
    ];
    casks = [
      "firefox"
      "ghostty"
      "arduino-ide"
      "anki"
      "alfred"
      "utm"
      "karabiner-elements"
      "keymapp"
      "rectangle"
      "thunderbird"
      "protonvpn"
      "google-chrome"
      "zwift"
    ];
    extraConfig = ''
      cask "spotify", args: { require_sha: false }
    '';
    masApps = {
      "Goodnotes 6" = 1444383602;
      "Azure VPN Client" = 1553936137;
      "BrightIntosh" = 6452471855;
    };
  };

  users.users.manuel.home = "/Users/manuel";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  nix.settings.experimental-features = "nix-command flakes";

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  nix.configureBuildUsers = true;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;
  system.defaults = {
    NSGlobalDomain = {
      "com.apple.swipescrolldirection" = false;
      "_HIHideMenuBar" = true;
      "InitialKeyRepeat" = 10;
      "KeyRepeat" = 1;
    };
    dock = {
      "autohide" = true;
      "launchanim" = false;
      "persistent-apps" = map (app: "/Applications/${app}.app") [
        "Ghostty"
      ];
    };
  };

  fonts.packages = with pkgs; [
    nerd-fonts.mononoki
  ];
}
