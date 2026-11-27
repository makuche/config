{
  config,
  pkgs,
  ...
}: {
  # common config
  imports = [../../common/darwin];

  system.primaryUser = "manuel";

  # cosmos-specific config
  users.users.manuel.home = "/Users/manuel";

  # cosmos-specific Homebrew packages
  homebrew = {
    taps = [
      "nikitabobko/tap"
      {
        name = "digitecgalaxus/dg";
        trusted = true;
      }
      "anomalyco/homebrew-tap"
      "clawkwork/tap"
    ];
    brews = [
      "anomalyco/homebrew-tap/opencode"
      "clawkwork/tap/clawk"
      "aiven-client"
      "dg-cli-preview"
      "sqlite" # required for qmd
      "xcodegen"
    ];

    casks = [
      "brave-browser"
      "dbeaver-community"
      "datagrip"
      "discord"
      "drawio"
      "finicky"
      "ghostty"
      "goland"
      "microsoft-teams"
      "nikitabobko/tap/aerospace"
      "little-snitch"
      "obsidian"
      "orbstack"
      "pritunl" # vpn
      "pycharm"
      "raycast"
      # "rex" # placeholder, no cask exists yet -> currently installed directly from the dmg
      "rider"
      "stats"
      "spotify"
      "tailscale-app"
      "utm"
      "visual-studio-code"
      "webstorm"
    ];
  };

  # cosmos-specific system defaults
  system.defaults = {
    NSGlobalDomain = {
      "_HIHideMenuBar" = true;
    };
    dock = {
      "autohide" = true;
      "persistent-apps" = map (app: "/Applications/${app}.app") [
        "Rex"
        "Brave Browser"
      ];
    };
  };
}
