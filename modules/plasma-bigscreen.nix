# stolen from https://github.com/itzTheMeow/dotfiles/blob/master/pkgs/plasma-bigscreen.nix (feeling thankful)
{ sources, pkgs, ... }:
let
  plasma-bigscreen = pkgs.callPackage "${sources.iTM-dots}/pkgs/plasma-bigscreen.nix" {};
in
{
  programs.kdeconnect.enable = true;
  services = {
    desktopManager.plasma6.enable = true;
    displayManager = {
      sddm.enable = true;
      autoLogin = {
        enable = true;
        user = "tipson";
      };
      defaultSession = "plasma-bigscreen-wayland";
      sessionPackages = [ plasma-bigscreen ];
    };
  };
  xdg.portal.configPackages = [ plasma-bigscreen ];
  environment.systemPackages = [ plasma-bigscreen ];
}
