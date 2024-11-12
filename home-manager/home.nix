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
    matplotlib
    pip
  ] ++ (if !pkgs.stdenv.isDarwin then [
    jupyter
    notebook
  ] else []);
  nixgl = import (fetchTarball "https://github.com/guibou/nixGL/archive/main.tar.gz") { inherit pkgs; };
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
    imports = [
    ../modules/symlinks.nix
  ];
  # This is needed as long as unstable.neovim is used
  home.enableNixpkgsReleaseCheck = false;

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
    zoxide

    # Development
    cargo
    git
    devbox

    # docker-client
    gh
    go
    jdk
    lazygit
    lua
    luarocks
    minikube
    nixfmt-rfc-style
    nodejs_22
    rustc
    sqlite
    tokei

    # Python development
    virtualenv
    (python312.withPackages python-packages)

    # Terminal enhancements
    figlet
    neofetch
    starship
    tmux

    # File management
    fdupes

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
    sioyek
    sqlitebrowser
    vscode  # needed for working on microcontroller

    # Presentation and documentation
    marp-cli

    # Network tools
    arp-scan
    nmap
    mosquitto
    openvpn

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
  home.sessionPath = [ "$HOME/.local/bin" ];
  programs.home-manager.enable = true;

  nixpkgs.config.allowUnfree = true;    # Allow unfree packages (obsidian)
}
