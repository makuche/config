{ config, pkgs, ... }:

let
  user = builtins.getEnv "USER";    # Use same setup with different users
  configDir = if pkgs.stdenv.isDarwin
    then "/Users/${user}/.config/dotfiles"
    else "/home/${user}/.config/dotfiles";
  unstable = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz") {
    config = config.nixpkgs.config;
  };
  python-packages = ps: with ps; [
   numpy
   debugpy
   pip
  ];
  nixgl = import (fetchTarball https://github.com/guibou/nixGL/archive/main.tar.gz) { inherit pkgs; };
  nixGLWrap = pkg: pkgs.runCommand "${pkg.name}-nixgl-wrapper" {} ''
    mkdir $out
    ln -s ${pkg}/* $out
    rm $out/bin
    mkdir $out/bin
    for bin in ${pkg}/bin/*; do
     wrapped_bin=$out/bin/$(basename $bin)
     echo "#!${pkgs.bash}/bin/bash" > $wrapped_bin
     echo "exec ${nixgl.auto.nixGLDefault}/bin/nixGL $bin \"\$@\"" >> $wrapped_bin
     chmod +x $wrapped_bin
    done
  '';
in
{
  home.username = user;
  home.homeDirectory = if pkgs.stdenv.isDarwin
    then "/Users/${user}"
    else "/home/${user}";
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
    lima
    mcfly
    pv
    ranger
    ripgrep
    tree
    wget
    zathura
    xclip
    zsh

    # Development tools
    cargo
    devbox
    gh
    jdk
    lazygit
    lua
    luarocks
    nixfmt-rfc-style
    nodejs_22
    rustc
    tokei
    vscode

    # Python development
    virtualenv
    # python312Packages.pip
    (python312.withPackages python-packages)

    # Terminal enhancements
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
    ffmpeg-full
    spotify
    spotify-player
    yt-dlp

    # GUI applications
    anki-bin
    obsidian

    # Presentation and documentation
    marp-cli

    # Network tools
    arp-scan
    nmap
    mosquitto

    # Commented out (to be addressed)
    # zsh-syntax-highlighting   # FIXME: This had to be installed via brew
  ] # macOS specific applications
    ++ (if pkgs.stdenv.isDarwin then [
      alacritty
      hidden-bar
      maccy
      unstable.neovim
    ] else [
        (nixGLWrap pkgs.alacritty)
        neovim
      ]);

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
