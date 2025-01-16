{ pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    settings = {
      monitor = [ # hyprctl monitors 
        "DVI-D-1, 1920x1080, 0x0, 1"
        "HDMI-A-3, 1920x1080, 1920x20, 1"
        ", preferred, auto, 1" # catch all for random monitors
      ];
    };
  };
}
