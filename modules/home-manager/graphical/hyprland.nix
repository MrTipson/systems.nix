{ pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
    extraConfig = ''
      input {
        numlock_by_default = true
      }
    '';
  };
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
}
