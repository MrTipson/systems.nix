{ config, lib, pkgs, ... }:
{
  boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usb_storage" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/storage" = {
    device = "storage";
    fsType = "zfs";
  };
  fileSystems."/storage/service" = {
    device = "storage/service";
    fsType = "zfs";
  };
  fileSystems."/storage/user" = {
    device = "storage/user";
    fsType = "zfs";
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
