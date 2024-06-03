{ config, pkgs, ... }:

let
  username = builtins.getEnv "USER";    # Use same setup with different users
in
{
  home.username = username;
  home.homeDirectory = "/Users/${username}";
  home.stateVersion = "24.05";
  home.packages = with pkgs; [
    bat
    htop
    wget
    gh
    pv  # Required to run demo.sh in presentation-tools
    #k9s
    #jq
    starship
    #yt-dlp    
    virtualenv
    python312Packages.pip
    
    obsidian
    vscode
  ];

  home.file = {
  };

  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;    # Allow unfree packages (obsidian)
}
