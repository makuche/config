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
    figlet
    hidden-bar
    jq
    tree
    fzf
    eza
    starship
    lazygit
    neovim
    mcfly
    ripgrep
    alacritty
    tokei
    tmux
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
    ".tmux.conf" = {
      source = "${configDir}/tmux.conf";
    };

    ".gitconfig" = {
      source = "${configDir}/gitconfig";
    };
  };

  programs.home-manager.enable = true;

  nixpkgs.config.allowUnfree = true;    # Allow unfree packages (obsidian)
}
