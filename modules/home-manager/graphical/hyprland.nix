{ pkgs, config, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
    settings = {
      env = [
        "ELECTRON_OZONE_PLATFORM_HINT,auto"
        "XCURSOR_THEME,${config.stylix.cursor.name}"
        "XCURSOR_SIZE,${builtins.toString config.stylix.cursor.size}"
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
