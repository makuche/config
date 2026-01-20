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
    taps = ["nikitabobko/tap"];
    brews = [
        "dotnet"
        "helm"
      # TODO: Add cosmos-specific brews here
    ];

    casks = [
      "brave-browser"
      "claude"
      "raycast"
      "nikitabobko/tap/aerospace"
      "obsidian"
      "ghostty"
      # TODO: Add cosmos-specific casks here
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
