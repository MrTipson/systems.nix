{ pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    settings = {
      env = [
        "LIBVA_DRIVER_NAME,nvidia"
        "NVD_BACKEND,direct" # https://wiki.hyprland.org/Nvidia/#va-api-hardware-video-acceleration
      ];
    };
  };
}
