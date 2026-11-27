{
  config,
  pkgs,
  ...
}: let
  # OrbStack mounts the Mac's files at their macOS paths
  fromMac = path: config.lib.file.mkOutOfStoreSymlink "/Users/manuel/${path}";
in {
  imports = [../../common/home-manager];

  # same work tools as hosts/cosmos/home.nix
  home.packages = with pkgs; [
    azure-cli
    go-task # `task` runner
    sqlcmd # SQL Server CLI
    viddy # modern `watch`
  ];

  # cosmos's key: this machine runs on cosmos. The secret key has to be imported once.
  programs.git.signing.key = "AA7B304D0375E65B";

  # The Mac's checkouts, so ~/git/... resolves as it does on macOS. The live-reload links in
  # common/home-manager (nvim, ghostty, rex) and extras point into ~/git/config and ~/git/_config.
  home.file."git".source = fromMac "git";

  # The Mac's SSH key, unlocked by keychain as on macOS. OrbStack forwards the macOS system
  # agent, but that one holds no keys: keychain runs its own.
  home.file.".ssh/id_ed25519".source = fromMac ".ssh/id_ed25519";
}
