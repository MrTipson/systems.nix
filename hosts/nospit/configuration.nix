{ pkgs, ... }:
{
  imports = with import ../../modules; [
    adguard
    avahi
    banked-rank-it
    caddy
    docker
    grist
    kiwix-serve
    nextcloud
    sops
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "nospit";
    nameservers = [
      "1.1.1.1"
    ];
    interfaces.enp1s0 = {
      ipv4.addresses = [
        {
          address = "192.168.64.228";
          prefixLength = 24;
        }
      ];
    };
    defaultGateway = {
      address = "192.168.64.1";
      interface = "enp1s0";
    };
    firewall.allowedTCPPorts = [
      80
      443
    ];
  };

  users.users = {
    tipson = {
      isNormalUser = true;
      extraGroups = [
        "wheel" # Enable ‘sudo’ for the user.
        "docker"
      ];
      shell = pkgs.fish;
    };
  };

  system.stateVersion = "24.11"; # don't change
}
