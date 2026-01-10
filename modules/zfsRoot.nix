# stealing stuff from https://github.com/iynaix/dotfiles/blob/main/modules/zfs.nix
{ lib, ... }:
let
  mount = m: {
    device = "zroot/" + m;
    fsType = "zfs";
  };
  needed = {
    neededForBoot = true;
  };
in
{
  fileSystems = {
    "/" = lib.mkDefault (mount "root"); # so impermanence can overwrite this
    "/nix" = mount "nix";
    "/tmp" = mount "tmp";
    "/cache" = mount "cache" // needed;
    "/persist" = mount "persist" // needed;
    "/boot" = {
      device = "/dev/disk/by-label/NIXBOOT";
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };
  };
  swapDevices = [ { device = "/dev/disk/by-label/SWAP"; } ];

  services.sanoid = {
    enable = true;

    datasets."zroot/persist" = {
      hourly = 50;
      daily = 15;
      weekly = 3;
      monthly = 1;
    };
  };
}
