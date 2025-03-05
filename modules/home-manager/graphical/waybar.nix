{ pkgs, config, ... }:
{
  stylix.targets.waybar.enable = false;
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    # doesnt merge with /hosts/masina/home-manager/waybar.nix
    settings.mainbar = {
      layer = "top";
      modules-left = ["hyprland/workspaces" "tray"];
      modules-center = ["hyprland/window"];
      modules-right = ["temperature#nvme-1" "temperature#nvme-2" "cpu" "temperature#cpu" "memory" "wireplumber" "custom/notification" "clock" "custom/power"];
      tray = {
        spacing = 4;
      };
      cpu = {
        format = "  {}%";
      };
      margin-top = -2;
      "temperature#nvme-1".format = "   {temperatureC}°C";
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

      "custom/power" = {
        format = "⏻";
        tooltip = false;
        menu = "on-click";
        menu-file = ./waybar-power-menu.xml;
        menu-actions = {
          shutdown = "systemctl poweroff";
          reboot = "reboot";
          suspend = "systemctl suspend";
          logout = "loginctl terminate-user \"\"";
        };
      };
      "custom/notification" = {
        "tooltip" = false;
        "format" = "{} {icon}";
        "format-icons" = {
          "notification" = "<span foreground='red'><sup></sup></span>";
          "none" = "";
          "dnd-notification" = "<span foreground='red'><sup></sup></span>";
          "dnd-none" = "";
          "inhibited-notification" = "<span foreground='red'><sup></sup></span>";
          "inhibited-none" = "";
          "dnd-inhibited-notification" = "<span foreground='red'><sup></sup></span>";
          "dnd-inhibited-none" = "";
        };
        "return-type" = "json";
        "exec-if" = "which swaync-client";
        "exec" = "swaync-client -swb";
        "on-click" = "swaync-client -t -sw";
        "on-click-right" = "swaync-client -d -sw";
        "escape" = true;
      };
    };
    # env GTK_DEBUG=interactive waybar -s waybar-style.css
    style = with config.lib.stylix.colors.withHashtag; /*css*/ ''
      @define-color base00 ${base00}; @define-color base01 ${base01}; @define-color base02 ${base02}; @define-color base03 ${base03};
      @define-color base04 ${base04}; @define-color base05 ${base05}; @define-color base06 ${base06}; @define-color base07 ${base07};
      @define-color base08 ${base08}; @define-color base09 ${base09}; @define-color base0A ${base0A}; @define-color base0B ${base0B};
      @define-color base0C ${base0C}; @define-color base0D ${base0D}; @define-color base0E ${base0E}; @define-color base0F ${base0F};
    ''
    + (with config.stylix; /*css*/ ''
      * {
        font-family: "${fonts.sansSerif.name}";
        font-size: ${builtins.toString fonts.sizes.desktop}pt;
      }

      window#waybar {
        font-family: Source Code Pro;
        background: alpha(@base00, ${builtins.toString opacity.desktop});
        color: @base05;
        font-size: small;
      }
      tooltip {
        background: alpha(@base00, ${builtins.toString opacity.popups});
        border-color: @base0D;
      }
      #cpu { color: @base08; margin-right: 0px; }
      #temperature.cpu { color: @base08; margin-left: 0px; }
      #memory { color: @base09; }
      #wireplumber { color: @base0A; }
      #custom-notification { color: @base0B; padding-right: 8px; }
      #clock { color: @color0C; }
      #custom-power { color: @base0D; padding-right: 8px; }
      .modules-right .module {
        padding: 1px 5px;
        margin: 0px 5px;
        border-top: 1px solid;
      }
      #workspaces button {
        padding: 0 5px;
        border-radius: 0px;
        border: 0px;
      }
      #workspaces button.visible {
        color: @base0D;
        border-top: 1px solid;
      }
      #workspaces button:hover {
        background: @base00;
        transition: none;
        text-shadow: none;
        box-shadow: none;
      }
      #workspaces {
        outline: none;
      }
      #tray {
        margin-left: 8px;
      }
    '');
  };
}
