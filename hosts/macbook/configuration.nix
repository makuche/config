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
      "duckdb"
      "dotnet"
      "helm"
      "geeqie"
      "git-crypt"
      "trivy"
    ];

    casks = [
      "anylist"
      "raycast"
      "brave-browser"
      "calibre"
      "claude"
      "dbeaver-community"
      "digikam"
      "docker-desktop"
      "drawio"
      "dropbox"
      "gimp"
      "ghostty"
      "lunar"
      "karabiner-elements"
      "keymapp"
      "macdown"
      "nikitabobko/tap/aerospace"
      "mochi"
      "obsidian"
      "parallels"
      "protonvpn"
      "proton-pass"
      "rectangle"
      "snagit"
      "stats"
      "signal"
      "tailscale-app"
      "thunderbird"
      "visual-studio-code"
      "vlc"
      "zwift"
    ];

    extraConfig = ''
      cask "spotify", args: { require_sha: false }
      cask "zwift", args: { require_sha: false }
    '';

    masApps = {
      "BrightIntosh" = 6452471855;
      "Desk Remote Control" = 1509037746;
      "Amphetamine" = 937984704;
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
