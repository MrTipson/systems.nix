{ pkgs, config, ... }:
{
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  # https://github.com/danth/stylix/issues/267
}
