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
    jq
    tree
    fzf
    eza
    starship
    lazygit 
    tmux
    neovim
    mcfly
    alacritty
    zsh-syntax-highlighting   # FIXME: This had to be installed via brew

    # Java development
    jdk

    # Python development
    virtualenv
    python312Packages.pip
    
    # Infrastructure
    minikube
    k9s 

    # GUI
    obsidian
    spotify
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
