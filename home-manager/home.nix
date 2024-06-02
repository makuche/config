{ config, pkgs, ... }:

{
  home.username = "manuel";
  home.homeDirectory = "/Users/manuel";
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
    obsidian
    vscode
  ];

  home.file = {
  };

  home.sessionVariables = {
  };

  programs.home-manager.enable = true;
}
