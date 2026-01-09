{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  imports = with import ../../modules; [
    avahi
    gaming
    grub
    multiseat
    nogreet
    pipewire
#    display-fix
    tailscale
  ];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];

  systemd.sleep.extraConfig = ''
    AllowSuspend=no
    AllowHibernation=no
    AllowHybridSleep=no
    AllowSuspendThenHibernate=no
  '';
  # virtualisation.waydroid.enable = true;

  networking = {
    hostName = "masina";
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [ 80 ];
  };

  users.users = {
    tipson = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "docker"
        "pipewire"
        "networkmanager"
      ];
      shell = pkgs.fish;
    };
    bimbo = {
      isNormalUser = true;
      extraGroups = [ ];
      shell = pkgs.fish;
    };
  };

  services.upower.enable = true;
  services.udisks2.enable = true;
  # security.polkit.enable = true;
  programs.dconf.enable = true; # for home manager/stylix

  environment.systemPackages = with pkgs; [
    sshfs
    home-manager
  ];

  system.stateVersion = "24.11"; # don't change
}
