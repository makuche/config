{
  config,
  pkgs,
  ...
}: {
  # common config
  imports = [../../common/darwin];

  system.primaryUser = "manuel";

  # MacBook-specific configuration
  users.users.manuel.home = "/Users/manuel";

  # MacBook-specific Homebrew packages
  homebrew = {
    taps = ["nikitabobko/tap"];
    brews = [
      # "duckdb"
      "exiftool"
      "helm"
      "geeqie"
      "git-crypt"
      "trivy"
    ];

    casks = [
      "raycast"
      "rawtherapee"
      "brave-browser"
      "calibre"
      "claude"
      "dbeaver-community"
      "docker-desktop"
      "flameshot"
      # "gimp"
      "ghostty"
      # TODO: use the nix-darwin settings: 
      # https://nix-darwin.github.io/nix-darwin/manual/#opt-services.aerospace.enable
      "nikitabobko/tap/aerospace"
      "obsidian"
      "parallels"
      "protonvpn"
      "proton-pass"
      "stats"
      "tailscale-app"
      "visual-studio-code"
      "vlc"
    ];

    masApps = {
      "Amphetamine" = 937984704;
      "BrightIntosh" = 6452471855;
      "Desk Remote Control" = 1509037746;
    };
  };

  # MacBook-specific system defaults
  system.defaults = {
    NSGlobalDomain = {
      "_HIHideMenuBar" = false;
    };
    dock = {
      "autohide" = true;
      "persistent-apps" = map (app: "/Applications/${app}.app") [
        "Ghostty"
        "Brave Browser"
      ];
    };
  };
}
