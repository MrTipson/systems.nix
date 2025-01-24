{ pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    settings = {
      monitor = [ # hyprctl monitors 
        "HDMI-A-3, 1920x1080, 0x0, 1"
        "DVI-D-1, 1920x1080, 1920x-550, 1, transform, 1"
        "Unknown-1, disable"
        ", preferred, auto, 1" # catch all for random monitors
      ];
    };
  };
}
