{ pkgs, lib, ... }:
{
  # https://bbs.archlinux.org/viewtopic.php?id=300192
  boot.kernelParams = [ "nvidia-drm.fbdev=0" "nvidia-drm.modeset=1" ];
  
  # hardware.nvidia.modesetting sets fbdev=1 and modeset=1, which we don't want
  hardware.nvidia.modesetting.enable = lib.mkForce false;
  hardware.display = {
    edid = {
      enable = true;
      linuxhw = { # https://github.com/linuxhw/EDID
        DELL_U2412M_2013 = [ "U2412M" "2013" "19BC92353E20" ];
      };
    };
    outputs."DVI-D-1" = {
      edid = "DELL_U2412M_2013.bin"; # from above
    };
  };
}
