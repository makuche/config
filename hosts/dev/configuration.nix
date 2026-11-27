# NixOS machine `dev` inside OrbStack, created with `orb create nixos:unstable dev`.
#
# This is the /etc/nixos/configuration.nix OrbStack generates, minus the certificates it
# copies from the macOS keychain: they belong to one Mac and this repo is public.
{modulesPath, ...}: {
  imports = [
    "${modulesPath}/virtualisation/lxc-container.nix"
    # Verbatim copy of /etc/nixos/orbstack.nix (OrbStack 2.2.5). OrbStack may regenerate its
    # own copy on updates: `diff /etc/nixos/orbstack.nix hosts/dev/orbstack.nix` shows drift.
    ./orbstack.nix
  ];

  networking.hostName = "dev";
  time.timeZone = "Europe/Zurich";

  users.users.manuel = {
    uid = 501;
    extraGroups = ["wheel" "orbstack" "audio"];
    isSystemUser = true;
    group = "users";
    createHome = true;
    home = "/home/manuel";
    homeMode = "700";
  };
  security.sudo.wheelNeedsPassword = false;
  users.mutableUsers = false;

  networking = {
    dhcpcd.enable = false;
    useDHCP = false;
    useHostResolvConf = false;
  };
  systemd.network = {
    enable = true;
    networks."50-eth0" = {
      matchConfig.Name = "eth0";
      networkConfig = {
        DHCP = "ipv4";
        IPv6AcceptRA = true;
      };
      linkConfig.RequiredForOnline = "routable";
    };
  };

  system.stateVersion = "26.11";
}
