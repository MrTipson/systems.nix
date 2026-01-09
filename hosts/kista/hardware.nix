{ lib, pkgs, ... }:
{
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
  };

  hardware = {
    enableRedistributableFirmware = true;
    cpu.intel.updateMicrocode = true;
  };
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
