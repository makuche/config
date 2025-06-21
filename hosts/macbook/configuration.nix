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
    brews = [
      "duckdb"
      "podman"
    ];

    casks = [
      "anylist"
      "alfred"
      "brave-browser"
      "calibre"
      "claude"
      "dbeaver-community"
      "drawio"
      "dropbox"
      "ghostty"
      "karabiner-elements"
      "keymapp"
      "macdown"
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
      "vlc"
      "zwift"
    ];

    extraConfig = ''
      cask "spotify", args: { require_sha: false }
    '';

    masApps = {
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
