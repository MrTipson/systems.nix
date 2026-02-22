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
    "/storage/zaklad" = {
      device = "storage/zaklad";
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
  users.groups.samba = { };
  services.samba = {
    # sudo smbpasswd -a my_user
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
        "hosts allow" = toString [
          "192.168.64." # local network
          "10.0.0." # lan
          "100.64.0." # tailscale network
          "127.0.0.1"
          "localhost"
        ];
        "hosts deny" = "0.0.0.0/0";
        "guest account" = "nobody";
        "map to guest" = "bad user";
      }
      # macos compatibility
      # idk how much of this is actually needed but i cant be bothered to check
      // {
        "vfs objects" = "catia fruit streams_xattr";
        "fruit:aapl" = "yes";
        "fruit:nfs_aces" = "no";
        "fruit:zero_file_id" = "yes";
        "fruit:metadata" = "stream";
        "fruit:encoding" = "native";
        "spotlight backend" = "tracker";
        "readdir_attr:aapl_rsize" = "no";
        "readdir_attr:aapl_finder_info" = "no";
        "readdir_attr:aapl_max_access" = "no";
        "fruit:model" = "MacSamba";
        "fruit:posix_rename" = "yes";
        "fruit:veto_appledouble" = "no";
        "fruit:wipe_intentionally_left_blank_rfork" = "yes";
        "fruit:delete_empty_adfiles" = "yes";

        # (OPTIONAL) Don't allow MacOS clients to write .DS_Store files to server shares
        "veto files" = "/.snap/.sujournal/._.DS_Store/.DS_Store/.Trashes/.TemporaryItems/";
        "delete veto files" = "yes";
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
      "zaklad" = {
        "path" = "/storage/zaklad";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0755";
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
