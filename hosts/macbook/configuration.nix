{
  config,
  pkgs,
  ...
}: {
  # common config
  imports = [../../common/darwin];

  # MacBook-specific configuration
  users.users.manuel.home = "/Users/manuel";

  # MacBook-specific Homebrew packages
  homebrew = {
    brews = [
      "argocd"
      "duckdb"
      "podman"
    ];

    casks = [
      "anylist"
      "alfred"
      "brave-browser"
      "calibre"
      "dbeaver-community"
      "dropbox"
      "ghostty"
      "keymapp"
      "mochi"
      "obsidian"
      "parallels"
      "protonvpn"
      "proton-pass"
      "rectangle"
      "stats"
      "tailscale"
      "thunderbird"
      "visual-studio-code"
      "zwift"
    ];

    extraConfig = ''
      cask "spotify", args: { require_sha: false }
    '';

    masApps = {
      "Goodnotes 6" = 1444383602;
      "Azure VPN Client" = 1553936137;
      "BrightIntosh" = 6452471855;
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
