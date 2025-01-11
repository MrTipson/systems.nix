{ pkgs, ... }:
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = [
      {
        layer = "top";
        modules-left = ["hyprland/workspaces" ];
        modules-center = ["hyprland/window"];
        modules-right = ["cpu" "temperature#cpu" "memory" "wireplumber" "clock" "custom/power"];
        cpu = {
          format = "  {}%";
        };
        "temperature#cpu" = {
          hwmon-path = "/sys/class/hwmon/hwmon2/temp1_input";
        };
        memory = {
          format = "   {percentage}%";
        };
        "hyprland/window" = {
          separate-outputs = true;
          icon = true;
        };
        clock = {
          format = "{:%H:%M}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "year";
            mode-mon-col = 3;
            on-scroll = 1;
            on-click-right = "mode";
            format = {
              months = "<span color='#ffead3'><b>{}</b></span>";
              days = "<span color='#ecc6d9'><b>{}</b></span>";
              weekdays = "<span color='#ffcc66'><b>{}</b></span>";
              today = "<span color='#1bf902' background='#063800'><b>{}</b></span>";
            };
          };
        };
        wireplumber = {
          format = "   {volume}%";
          format-muted = "";
          on-click = "pwvucontrol";
          on-click-middle = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          on-click-right = "qpwgraph";
          tooltip = false;
          max-volume = 150;
          scroll-step = 0.2;
        };

        "custom/power" = {
          format = "⏻";
          tooltip = false;
          menu = "on-click";
          menu-file = ./waybar-power-menu.xml;
          menu-actions = {
            shutdown = "shutdown";
            reboot = "reboot";
            suspend = "systemctl suspend";
            logout = "loginctl terminate-user \"\"";
          };
        };
      }
    ];
    # env GTK_DEBUG=interactive waybar -s waybar-style.css
    style = ./waybar-style.css;
  };
}
