{ pkgs, ... }:
{
  programs.waybar.settings = [
    {
      "temperature#cpu" = {
        hwmon-path = "/sys/class/hwmon/hwmon2/temp1_input";
      };
    }
  ];
}
