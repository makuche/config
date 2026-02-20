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
    taps = ["nikitabobko/tap" "digitecgalaxus/dg"];
    brews = [
      "azure-cli"
      "dg-cli"
      "helm"
      "sqlite" # required for qmd
    ];

    casks = [
      "brave-browser"
      "claude-code"
      "dbeaver-community"
      "discord"
      "drawio"
      "ghostty"
      "microsoft-teams"
      "nikitabobko/tap/aerospace"
      "lulu"
      "obsidian"
      "orbstack"
      "pritunl" # vpn
      "raycast"
      "rider"
      "stats"
      "spotify"
      "visual-studio-code"
    ];
  };

  # cosmos-specific system defaults
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
