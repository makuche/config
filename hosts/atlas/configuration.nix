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
    taps = ["nikitabobko/tap" "FelixKratz/formulae" "clawkwork/tap" "anomalyco/tap"];
    brews = [
      # "duckdb"
      "anomalyco/tap/opencode"
      "clawkwork/tap/clawk"
      "exiftool"
      "FelixKratz/formulae/borders"
      "helm"
      "geeqie"
      "git-crypt"
      "trivy"
    ];

    casks = [
      "background-music"
      "brave-browser"
      "calibre"
      "claude"
      "darktable"
      "dbeaver-community"
      "flameshot"
      "ghostty"
      "nikitabobko/tap/aerospace"
      "obsidian"
      "orbstack"
      "parallels"
      "proton-pass"
      "protonvpn"
      "rawtherapee"
      "raycast"
      "rider"
      "stats"
      "signal"
      {
        # spotify's cask ships sha256 :no_check, exempt it from global require_sha
        name = "spotify";
        args.require_sha = false;
      }
      "tailscale-app"
      "visual-studio-code"
      "vlc"
      # https://nix-darwin.github.io/nix-darwin/manual/#opt-services.aerospace.enable
      # TODO: use the nix-darwin settings:
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
      "_HIHideMenuBar" = true;
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
