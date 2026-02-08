{ lib, pkgs, ... }:
{
  imports = with import ../../modules; [
    zfs
    zfsRoot
  ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ehci_pci"
    "ahci"
    "usb_storage"
    "sd_mod"
    "sr_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems = {
    "/storage" = {
      device = "storage";
      fsType = "zfs";
    };
    "/storage/service" = {
      device = "storage/service";
      fsType = "zfs";
    };
    "/storage/user" = {
      device = "storage/user";
      fsType = "zfs";
    };
    # sudo zfs create -o mountpoint=legacy storage/music
    # sudo zfs set sharenfs=on storage/music
    "/storage/music" = {
      device = "storage/music";
      fsType = "zfs";
    };
  };

  users.users.samba = {
    isSystemUser = true;
    description = "Samba users";
    group = "samba";
  };
  users.groups.samba = {};
  services.samba = { # sudo smbpasswd -a my_user
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "skrinja";
        "netbios name" = "skrinja";
        "security" = "user";
        #"use sendfile" = "yes";
        # "min protocol" = "smb3";
        #"max protocol" = "smb2";
        # note: localhost is the ipv6 localhost ::1
        "hosts allow" = "192.168.64. 10.0.0. 127.0.0.1 localhost";
        "hosts deny" = "0.0.0.0/0";
        "guest account" = "nobody";
        "map to guest" = "bad user";
      };
      "music" = {
        "path" = "/storage/music";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "samba";
        "force group" = "samba";
      };
    };
  };

  hardware = {
    enableRedistributableFirmware = true;
    cpu.intel.updateMicrocode = true;
  };
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
