{ pkgs, ... }:
{
  imports = with import ../../modules; [
    adguard
    avahi
    caddy
    docker
    grist
    kiwix-serve
    nextcloud
    pipewire
    plasma-bigscreen
    sops
    # custom options
    share-network
    tailscale
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "nospit";
    nameservers = [
      "1.1.1.1"
    ];
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [
      80
      443
    ];
    # custom option
    share = {
      from = "wlo1";
      to = "enp1s0";
    };
  };
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
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
