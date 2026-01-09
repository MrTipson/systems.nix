{ lib, pkgs, ... }:
{
  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "ahci"
    "usbhid"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/d4c51a72-2b9a-45c0-85f7-78d48b762784";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/E6AA-D19A";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
      ];
    };
    # "/mnt/win" = {
    #   device = "/dev/disk/by-uuid/24B09880B0985A5E";
    #   fsType = "ntfs3";
    # };
  };
  swapDevices = [ ];

  hardware = {
    enableRedistributableFirmware = true;
    cpu.amd.updateMicrocode = true;
  };
  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
