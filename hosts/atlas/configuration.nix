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
    taps = ["nikitabobko/tap" "FelixKratz/formulae"];
    brews = [
      # "duckdb"
      "exiftool"
      "FelixKratz/formulae/borders"
      "helm"
      "geeqie"
      "git-crypt"
      "trivy"
    ];

    casks = [
      "brave-browser"
      "calibre"
      "claude"
      "dbeaver-community"
      "flameshot"
      "ghostty"
      "nikitabobko/tap/aerospace"
      "obsidian"
      "parallels"
      "proton-pass"
      "protonvpn"
      "rawtherapee"
      "raycast"
      "stats"
      "tailscale-app"
      "visual-studio-code"
      "vlc"
      # "gimp"
      # TODO: use the nix-darwin settings:
      # https://nix-darwin.github.io/nix-darwin/manual/#opt-services.aerospace.enable
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
      "ApplePressAndHoldEnabled" = true;
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
