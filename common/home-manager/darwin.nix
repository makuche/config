# macOS-only user configuration. Imported on every host, does nothing on Linux.
{
  pkgs,
  lib,
  ...
}: {
  config = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    home.file.".aerospace.toml".source = ../../assets/aerospace.toml;
  };
}
