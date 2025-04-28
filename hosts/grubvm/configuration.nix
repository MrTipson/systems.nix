# sudo nixos-rebuild build-vm-with-bootloader --flake ~/nixos#grubvm
# env QEMU_OPTS="-virtfs local,path=/home/tipson/nixos,security_model=none,mount_tag=nixconfig -m 4096" /nix/store/...-nixos-vm/bin/run-nixos-vm
{ pkgs, lib, config, ... }:
{
  imports = with import ../../modules; [
    ../default/configuration.nix
    # grub # build errors when trying to build the vm; uncomment when inside 
  ];

  config = {
    services.qemuGuest.enable = true;

    fileSystems."/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
      autoResize = true;
    };
    
    networking.hostName = "grubvm";
    boot.initrd.postMountCommands = ''
      mkdir -p "$targetRoot/root/nixconfig"
      mount -t 9p "nixconfig" "$targetRoot/root/nixconfig" -o trans=virtio,version=9p2000.L,cache=none
    '';
    documentation.man.generateCaches = false;

    environment.systemPackages = [ pkgs.grub2 ];
    # Give root an empty password to ssh in.
    users.extraUsers.root.password = "";
    users.mutableUsers = false;

    system.stateVersion = "25.05";
  };
}