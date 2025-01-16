{ pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
    settings = {
      env = [
        "ELECTRON_OZONE_PLATFORM_HINT,auto"
      ];
      decoration.blur.enabled = false;
    };
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
