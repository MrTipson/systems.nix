{ pkgs, ... }:
{
  # doesnt merge with /modules/home-manager/graphical/waybar.nix
  programs.waybar.settings.mainbar = {
    "temperature#cpu".hwmon-path = "/sys/class/hwmon/hwmon2/temp1_input";
    "temperature#nvme-1".hwmon-path = "/sys/class/hwmon/hwmon1/temp1_input";
    "temperature#nvme-2".hwmon-path = "/sys/class/hwmon/hwmon0/temp1_input";
  };
}
