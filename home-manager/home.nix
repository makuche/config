{ pkgs, ... }:
 let
  unstable = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz") {};
in
{
  home.stateVersion = "24.05";
  programs.git = {
    enable = true;
    userName = "user name";
    userEmail = "email";
  };
  
  home.packages = with pkgs; [
     tree-sitter
     nixd
     unstable.neovim
     htop
     lazygit
  ];

}
