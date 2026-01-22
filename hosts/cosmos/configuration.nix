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
        "dotnet"
        "helm"
        "dg-cli"
    ];

    casks = [
      "brave-browser"
      "claude-code"
      "ghostty"
      "microsoft-teams"
      "nikitabobko/tap/aerospace"
      "obsidian"
      "pritunl" # vpn
      "raycast"
      "spotify"
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
