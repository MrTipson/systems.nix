# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  nixpkgs.config.allowUnfree = true;

  imports = with import ../../modules; [
    ../default/configuration.nix
    ./hardware-configuration.nix # Include the results of the hardware scan.
    avahi
    gaming
    greetd
    grub
    nvidia
    registry
#    display-fix
    kde
    tailscale
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];

  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
    };
  };
  networking.hostName = "masina"; # Define your hostname.

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tipson = {
    isNormalUser = true;
    extraGroups = [
      "wheel" # Enable ‘sudo’ for the user.
      "docker"
    ];
    shell = pkgs.fish;
  };
  users.users.bimbo = {
    isNormalUser = true;
    extraGroups = [ ];
    shell = pkgs.fish;
  };

  security.polkit.enable = true;
  
  environment.systemPackages = with pkgs; [
    sshfs
  ];

  networking.firewall.allowedTCPPorts = [
    22
    80
  ];

  system.stateVersion = "24.11"; # DO NOT CHANGE https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion
}
