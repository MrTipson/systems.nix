{ pkgs, ... }:
{
  systemd.user.services.polkit-soteria = { # nixpkgs/nixos/modules/security/soteria.nix
    Unit = {
      Description = "Soteria, Polkit authentication agent for any desktop environment";
      Wants = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Install.WantedBy = [ "graphical-session.target" ];
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.soteria}/bin/soteria";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
}
