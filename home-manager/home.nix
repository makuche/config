{ config, pkgs, ... }:

let
  username = builtins.getEnv "USER";    # Use same setup with different users
in
{
  home.username = username;
  home.homeDirectory = "/Users/${username}";
  home.stateVersion = "24.05";
  home.packages = with pkgs; [
    # CLI
    bat
    htop
    wget
    gh
    pv  # Required to run demo.sh in presentation-tools
    starship
    
    # Python development
    virtualenv
    python312Packages.pip
    
    # GUI
    obsidian
    vscode
  ];

  home.file = {
  };

  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;    # Allow unfree packages (obsidian)
}
