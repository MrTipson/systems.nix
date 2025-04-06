{ pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    settings = {
      monitor = [ # hyprctl monitors 
        "DP-4, 2560x1440@240, 0x0, 1"
        "DVI-D-1, 1920x1080, 2560x0, 1, transform, 1"
        "Unknown-1, disable"
        ", preferred, auto, 1" # catch all for random monitors
      ];
    };
  };
}
