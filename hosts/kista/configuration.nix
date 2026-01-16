{ pkgs, ... }:
{
  imports = with import ../../modules; [
    avahi
    impermanence
    sailing
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "kista";
    hostId = "74dbcdb0"; # needed for zfs
    networkmanager.enable = true;
    nameservers = [ "1.1.1.1" ];
  };

  # impermanence stubs users
  custom.users = {
    tipson = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      shell = pkgs.fish;
    };
  };

  system.stateVersion = "25.11"; # don't change
}
