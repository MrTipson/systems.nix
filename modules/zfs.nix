# stealing stuff from https://github.com/iynaix/dotfiles/blob/main/modules/zfs.nix
{ pkgs, lib, ... }:
let
  mount = m: { 
    device = "zroot/" + m;
    fsType = "zfs";
  };
  needed = { neededForBoot = true; };
in
{
  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;
  boot.zfs = {
    devNodes = "/dev/disk/by-id";
    package = pkgs.zfs_unstable;
  };

  fileSystems = {
    "/" = mount "root";
    "/nix" = mount "nix";
    "/tmp" = mount "tmp";
    "/cache" = mount "cache" // needed;
    "/persist" = mount "persist" // needed;
    "/boot" = { 
      device = "/dev/disk/by-label/NIXBOOT";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };
    
  };
  swapDevices = [{ device = "/dev/disk/by-label/SWAP"; }];

  # https://github.com/openzfs/zfs/issues/10891
  systemd.services.systemd-udev-settle.enable = false;

  services.sanoid = {
    enable = true;

    datasets."zroot/persist" = {
      hourly = 50;
      daily = 15;
      weekly = 3;
      monthly = 1;
    };
  };

  # show compress ratio in zfs list output
  environment.shellAliases.zls = "zfs list -o name,used,avail,compressratio";
}
