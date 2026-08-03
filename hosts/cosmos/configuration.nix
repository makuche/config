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
    taps = ["nikitabobko/tap" "digitecgalaxus/dg" "FelixKratz/formulae" "anomalyco/homebrew-tap" "clawkwork/tap"];
    brews = [
      "FelixKratz/formulae/borders"
      "anomalyco/homebrew-tap/opencode"
      "clawkwork/tap/clawk"
      "azure-cli"
      "aiven-client"
      "dg-cli"
      "go-task"
      "helm"
      "sqlcmd"
      "sqlite" # required for qmd
      "viddy"
    ];

    casks = [
      "brave-browser"
      "dbeaver-community"
      "datagrip"
      "discord"
      "drawio"
      "flameshot"
      "finicky"
      "ghostty"
      "goland"
      "microsoft-teams"
      "nikitabobko/tap/aerospace"
      "lulu"
      "little-snitch"
      "obsidian"
      "orbstack"
      "pritunl" # vpn
      "pycharm"
      "raycast"
      "rider"
      "stats"
      "spotify"
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
        "Ghostty"
        "Brave Browser"
      ];
    };
  };
}
