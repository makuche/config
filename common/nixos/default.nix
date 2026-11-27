# Shared by every NixOS host: the Linux counterpart of common/darwin.
{pkgs, ...}: {
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs.config.allowUnfree = true; # terraform, claude-code

  programs.zsh.enable = true;
  # home-manager runs compinit itself (common/home-manager), once is enough
  programs.zsh.enableGlobalCompInit = false;
  # NixOS predefines these three aliases. home-manager brings its own, and an alias named
  # `ll` turns the `ll() {...}` function in .zshrc into a parse error that aborts the file.
  environment.shellAliases = {
    ls = null;
    ll = null;
    l = null;
  };
  users.users.manuel = {
    shell = pkgs.zsh;
    extraGroups = ["docker"];
  };

  # Lets prebuilt Linux binaries run that expect the usual loader path: the language servers
  # Mason downloads for nvim, uv's Python builds, SDKs installed into ~/.dotnet.
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = [pkgs.icu]; # .NET needs ICU on top of the default set

  virtualisation.docker.enable = true;

  # The extras flake input is fetched from GitHub over SSH on every rebuild
  programs.ssh.knownHosts."github.com".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
}
