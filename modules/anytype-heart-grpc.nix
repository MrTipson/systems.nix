{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
{
  # users.users.anytype-heart = {
  #   home = "/var/lib/anytype-heart";
  #   createHome = true;
  #   isSystemUser = true;
  #   group = "anytype-heart";
  # };
  # users.groups.anytype-heart = { };

  # boot.kernel.sysctl."net.ipv6.conf.eth0.disable_ipv6" = true;
  networking.enableIPv6 = false;

  # nixpkgs.config.allowUnfree = true;
  #
  networking = {
    firewall = {
      allowedTCPPorts = [ 31007 ];
    };
  };

  # -beta experimental \
  systemd.services.anytype-heart-grpc = {
    script = ''
      /home/tipson/devel/anytype-heart/dist/server
    '';
    serviceConfig = {
      Restart = "always";
      User = "tipson";
      # User = "anytype-heart";
      # WorkingDirectory = "/var/lib/anytype-heart";
    };
  };
}
