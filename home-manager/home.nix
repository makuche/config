{ config, pkgs, ... }:

let
  username = builtins.getEnv "USER";    # Use same setup with different users
  configDir = "/Users/${username}/.config/dotfiles";
in
{
  home.username = username;
  home.homeDirectory = "/Users/${username}";
  home.stateVersion = "24.05";

  imports = [
    ./tmux.nix  # Import the tmux configuration from an external file
  ];

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
    ripgrep
    alacritty
    tokei
    spotify-player
#    zsh-syntax-highlighting   # FIXME: This had to be installed via brew

    # general dev
    jdk
    lua

    # Python development
    virtualenv
    python312Packages.pip
    nodejs_22
    
    # GUI
    grafana
    obsidian
    vscode
    maccy
    anki-bin

    # Misc
    presenterm
    gnupg
  ];

  home.file = {
    ".zshrc" = {
      source = "${configDir}/zshrc";
    };
  };

  programs.home-manager.enable = true;

  nixpkgs.config.allowUnfree = true;    # Allow unfree packages (obsidian)
}
