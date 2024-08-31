{ config, pkgs, ... }:

let
  username = builtins.getEnv "USER";    # Use same setup with different users
  configDir = "/Users/${username}/.config/dotfiles";
  unstable = import (fetchTarball https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz) {
    config = config.nixpkgs.config;
  };
  python-packages = ps: with ps; [
   numpy
  ];
in
{
  home.username = username;
  home.homeDirectory = "/Users/${username}";
  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    # Core utilities
    bat
    diff-so-fancy
    eza
    fd
    fzf
    htop
    jq
    mcfly
    pv
    ripgrep
    tree
    wget

    # Development tools
    cargo
    devbox
    gh
    jdk
    lazygit
    lua
    luarocks
    nmap
    nodejs_22
    rustc
    tokei
    unstable.neovim
    vscode

    # Python development
    virtualenv
    python312Packages.pip
    (python312.withPackages python-packages)

    # Terminal enhancements
    alacritty
    figlet
    starship
    tmux

    # File management
    fdupes

    # Version control
    git

    # Text processing
    gnupg

    # Multimedia
    spotify
    spotify-player

    # GUI applications
    anki-bin
    hidden-bar
    maccy
    obsidian

    # Presentation and documentation
    marp-cli

    # Network tools
    mosquitto

    # Commented out (to be addressed)
    # zsh-syntax-highlighting   # FIXME: This had to be installed via brew
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
    };  # TODO: Add alacritty config here as well
  };

  programs.home-manager.enable = true;

  nixpkgs.config.allowUnfree = true;    # Allow unfree packages (obsidian)
}
