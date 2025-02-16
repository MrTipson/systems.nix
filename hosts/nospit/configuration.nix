# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  inputs,
  myconfig,
  ...
}:

{
  nixpkgs.overlays = with import ../../overlays; [ ];

  imports = with import ../../modules/nixos; [
    ../default/configuration.nix
    ./hardware-configuration.nix # Include the results of the hardware scan.
    adguard
    anytype-heart-grpc
    avahi
    caddy
    docker
    grist
    nextcloud
    sops
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
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
  };
  networking.hostName = "nospit"; # Define your hostname.

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tipson = {
    isNormalUser = true;
    extraGroups = [
      "wheel" # Enable ‘sudo’ for the user.
      "docker"
    ];
    shell = pkgs.fish;
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; inherit myconfig; };
    useGlobalPkgs = true;
    useUserPackages = true;
    users = {
      "tipson" = import ../../users/mrtipson;
    };
  };

  environment.systemPackages = with pkgs; [
    #anytype-heart-grpc
  ];

  networking.firewall.allowedTCPPorts = [
    22
    80
    443
  ];

  system.stateVersion = "24.11"; # DO NOT CHANGE https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion
}
