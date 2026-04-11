{pkgs, ...}: let
  defaultBrowser = "com.brave.Browser";
in {
  # common system config (git provided by xcode-select --install)
  homebrew = {
    enable = true;
    global.autoUpdate = true;
    global.brewfile = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };
    caskArgs = {
      require_sha = true;
    };
  };
  nix.settings.experimental-features = "nix-command flakes";
  nix.enable = false;
  system.stateVersion = 5;
  # common platform configuration
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true; # required for terraform installation
  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;
  # common system defaults
  system.defaults = {
    NSGlobalDomain = {
      "com.apple.swipescrolldirection" = false;
      "InitialKeyRepeat" = 10;
      "KeyRepeat" = 1;
      "NSAutomaticWindowAnimationsEnabled" = false; # disable animations
    };
    dock = {
      "launchanim" = false;
    };
    CustomUserPreferences."com.apple.symbolichotkeys" = {
      AppleSymbolicHotKeys = {
        # 60 = Select previous input source (Ctrl+Space) disabled for tmux
        "60" = {
          enabled = false;
          value = {
            parameters = [32 49 262144];
            type = "standard";
          };
        };
        # 61 = Select next input source (Ctrl+Option+Space) disabled for tmux
        "61" = {
          enabled = false;
          value = {
            parameters = [32 49 786432];
            type = "standard";
          };
        };
        # 64 = Spotlight Search (Cmd+Space) disabled for Raycast
        "64" = {
          enabled = false;
          value = {
            parameters = [32 49 1048576];
            type = "standard";
          };
        };
        # 65 = Spotlight Window (Cmd+Option+Space) disabled for Raycast
        "65" = {
          enabled = false;
          value = {
            parameters = [32 49 1572864];
            type = "standard";
          };
        };
      };
    };
  };

  fonts.packages = with pkgs; [
    nerd-fonts.mononoki
  ];
  # Enable Touch ID for sudo
  security.pam.services.sudo_local.touchIdAuth = true;
}
