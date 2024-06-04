{ config, pkgs, ... }:

let
  username = builtins.getEnv "USER";    # Use same setup with different users
  configDir = "/Users/${username}/.config/dotfiles";
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
    
    # Java development
    jdk
    
    # Python development
    virtualenv
    python312Packages.pip
    
    # GUI
    obsidian
    vscode
  ];

  home.file = {
    ".zshrc" = {
      source = "${configDir}/zshrc";
    };
  };

  programs.home-manager.enable = true;

  nixpkgs.config.allowUnfree = true;    # Allow unfree packages (obsidian)
}
