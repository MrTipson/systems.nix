{ pkgs, ... }:
{
  home.packages = [ pkgs.qpwgraph pkgs.pwvucontrol ];
  programs.waybar.settings.mainbar = {
    wireplumber = {
      format = "   {volume}%";
      format-muted = "";
      on-click = "pwvucontrol";
      on-click-middle = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
      on-click-right = "qpwgraph";
      tooltip = false;
      max-volume = 150;
      scroll-step = 0.5;
    };
  };
}
