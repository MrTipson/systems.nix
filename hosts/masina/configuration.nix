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
  nixpkgs.overlays = with import ../../overlays; [
    inputs.nur.overlays.default
  ];

  imports = with import ../../modules/nixos; [
    ../default/configuration.nix
    ./hardware-configuration.nix # Include the results of the hardware scan.
    gaming
    greetd
    nvidia
    display-fix
    hyprland
    kde
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
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

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    useGlobalPkgs = true;
    useUserPackages = true;
    sharedModules = with import ./home-manager; [
      hyprland
      waybar
      inputs.stylix.homeManagerModules.stylix
    ];
    users = {
      "tipson" = import ../../users/mrtipson;
    };
  };

  security.polkit.enable = true;
  
  environment.systemPackages = with pkgs; [
  ];

  networking.firewall.allowedTCPPorts = [
    22
    80
  ];

  system.stateVersion = "24.11"; # DO NOT CHANGE https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion
}
