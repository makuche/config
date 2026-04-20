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
    taps = ["nikitabobko/tap" "digitecgalaxus/dg" "FelixKratz/formulae"];
    brews = [
      "FelixKratz/formulae/borders"
      "azure-cli"
      "dg-cli"
      "helm"
      "sqlcmd"
      "sqlite" # required for qmd
      "viddy"
    ];

    casks = [
      "brave-browser"
      "dbeaver-community"
      "discord"
      "drawio"
      "flameshot"
      "ghostty"
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
      "visual-studio-code"
      "webstorm"
    ];
  };

  # cosmos-specific system defaults
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
