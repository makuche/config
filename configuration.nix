{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    git # for bootstrapping the system
  ];

  homebrew = {
    enable = true;
    global.autoUpdate = false;
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
    ];
    casks = [
      "alacritty"
      "firefox"

      "anki"
      "alfred"
      "utm"
      "keymapp"
      "rectangle"
      "thunderbird"
      "protonmail-bridge"
      "protonvpn"
      "google-chrome"
      # "vmware-fusion" #TODO: Maybe completely switch to utm
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
        "Firefox"
        "Goodnotes"
      ];
    };
  };

  fonts.packages = with pkgs; [
    nerd-fonts.mononoki
  ];
}
