{ config, pkgs, ...}: 
{ 
  services.xserver.displayManager.startx.enable = true;
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        # if you want to boot into terminal, switch to one of the other ttys
        # by default we are on tty1, you can switch to tty1-6 with CTRL + ALT + F1-6
        command = with config.services.displayManager.sessionData; (
          "${pkgs.greetd.tuigreet}/bin/tuigreet" +
          " --xsessions ${desktops}/share/xsessions" +
          " --sessions ${desktops}/share/wayland-sessions" +
          " --remember --remember-user-session"
        );
        user = "greeter";
      };
    };
  };
  # Fix kernel logs sometimes appearing over tuigreet
  systemd.services.greetd.unitConfig.After = [ "multi-user.target" ];
}