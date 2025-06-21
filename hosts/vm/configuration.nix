{
  config,
  pkgs,
  ...
}: {
  # common config
  imports = [../../common/darwin];

  system.primaryUser = "smc";

  # VM-specific config
  users.users.smc.home = "/Users/smc";

  # VM-specific Homebrew packages
  homebrew = {
    brews = [
      "unixodbc"
      "duckdb"
      "azcopy"
      "azure-cli"
    ];

    casks = [
      "alfred"
      "brave-browser"
      "dbeaver-community"
      "ghostty"
      "visual-studio-code"
      "libreoffice"
      "microsoft-excel"
      "proton-pass"
      "rectangle"
    ];
  };

  # VM-specific system defaults
  system.defaults = {
    NSGlobalDomain = {
      "_HIHideMenuBar" = false;
    };
    dock = {
      "autohide" = false;
      "persistent-apps" = map (app: "/Applications/${app}.app") [
        "Ghostty"
        "Google Chrome"
        "Brave Browser"
        "Azure VPN Client"
      ];
    };
  };
}
