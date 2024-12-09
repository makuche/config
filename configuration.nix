{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vim
    curl
  ];

  homebrew = {
    enable = true;
    global.autoUpdate = false;

    casks = [ 
        "alacritty"
        "firefox" 
        "spotify"
        "vmware-fusion"
	"thunderbird"

    ];
    masApps = {
      "Keymapp"  = 6472865291;
      "Magnet" = 441258766;
      "Goodnotes 6" = 1444383602;
    };
  };

  users.users.manuel.home = "/Users/manuel";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  nix.settings.experimental-features = "nix-command flakes";


  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  nix.configureBuildUsers = true;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
  system.keyboard.enableKeyMapping  = true;
  system.keyboard.remapCapsLockToEscape = true;
  system.defaults = { 
    NSGlobalDomain = {
      "com.apple.swipescrolldirection" = false;
      "_HIHideMenuBar" = true;
    };
    dock = {
      "autohide" = true;
      "launchanim" = false;
      "persistent-apps" = [
        "/Applications/Firefox.app"
	"/Applications/Alacritty.app"
	"/Applications/VMware Fusion.app/"
	"/Applications/keymapp.app/"
	"/Applications/Goodnotes.app/"
      ];
    };
  };
}
