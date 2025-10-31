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
    grub
    multiseat
    nogreet
    pipewire
    registry
#    display-fix
    tailscale
  ];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];

  networking.hostName = "masina"; # Define your hostname.

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tipson = {
    isNormalUser = true;
    extraGroups = [
      "wheel" # Enable ‘sudo’ for the user.
      "docker"
      "pipewire"
      "networkmanager"
    ];
    shell = pkgs.fish;
  };
  users.users.bimbo = {
    isNormalUser = true;
    extraGroups = [ ];
    shell = pkgs.fish;
  };

  services.upower.enable = true;
  networking.networkmanager.enable = true;
  services.udisks2.enable = true;
  # security.polkit.enable = true;
  programs.dconf.enable = true; # for home manager/stylix
  
  environment.systemPackages = with pkgs; [
    sshfs
    home-manager
  ];

  networking.firewall.allowedTCPPorts = [
    22
    80
  ];

  system.stateVersion = "24.11"; # DO NOT CHANGE https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion
}
