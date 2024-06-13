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
    diff-so-fancy
    htop
    wget
    gh
    pv  # Required to run demo.sh in presentation-tools
    fdupes # Remove duplicate files
    hidden-bar
    starship
    lazygit 
    tmux
    mcfly

    # Java development
    jdk

    # Python development
    virtualenv
    python312Packages.pip
    
    # Infrastructure
    podman
    kubectl
    minikube
    k9s 

    # GUI
    obsidian
    vscode
    maccy
  ];

  home.file = {
    ".zshrc" = {
      source = "${configDir}/zshrc";
    };
  };

  programs.home-manager.enable = true;

  nixpkgs.config.allowUnfree = true;    # Allow unfree packages (obsidian)
}
