{ config, lib, pkgs, ... }@args:

with lib;
let
  isDarwin = pkgs.stdenv.isDarwin;

  mkSymlink = path:
    pkgs.runCommandLocal (baseNameOf (toString path)) {} ''
      ln -s ${escapeShellArg (toString path)} $out
    '';

  home = config.home.homeDirectory;

  symlinks = [
    {
      name = "lazygit";
      source = "${home}/.config/lazygit/config.yml";
      target = {
        darwin = "Library/Application Support/lazygit/config.yml";
      };
    }
  ];

  makeSymlinks = links:
    let
      validLinks = builtins.filter
        (link:
          if isDarwin
          then link.target ? darwin
          else link.target ? linux
        )
        links;
    in
    builtins.listToAttrs (map
      (link: {
        name = if isDarwin then link.target.darwin else link.target.linux;
        value = {
          source = mkSymlink link.source;
        };
      })
      validLinks);
in
{
  home.file = makeSymlinks symlinks;
}

