# Linux-only user configuration. Imported on every host, does nothing on macOS.
{
  pkgs,
  lib,
  ...
}: {
  config = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    home.packages = with pkgs; [
      claude-code # macOS uses the native installer in ~/.local/bin
      gcc # builds tree-sitter parsers and telescope-fzf-native (macOS has Xcode's cc)
      gnumake
      lsof # for the `ports` alias
      roslyn-ls # C# language server for nvim: Mason's build cannot find OpenSSL on NixOS
      unzip # Mason unpacks some language servers with it
    ];

    # git signs commits with gpg (programs.git.signing); without a display the passphrase
    # prompt has to be a terminal one
    services.gpg-agent = {
      enable = true;
      pinentry.package = pkgs.pinentry-curses;
    };
  };
}
