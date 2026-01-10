# stealing stuff from https://github.com/iynaix/dotfiles/blob/main/modules/zfs.nix
{ pkgs, lib, ... }:
{
  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;
  boot.zfs = {
    devNodes = "/dev/disk/by-id";
    package = pkgs.zfs_unstable;
  };

  # https://github.com/openzfs/zfs/issues/10891
  systemd.services.systemd-udev-settle.enable = false;

  # show compress ratio in zfs list output
  environment.shellAliases.zls = "zfs list -o name,used,avail,compressratio";
}
