{ config, pkgs, lib, ... }:
{
  services.adguardhome = {
    enable = true;
    mutableSettings = false;
    settings = {
      dns.bootstrap_dns = [ "1.1.1.1" ];
    };
  };

  systemd.services.mDNS-adguard = lib.mkIf config.services.avahi.enable {
    enable = true;
    after = [ "adguardhome.service" ];
    wantedBy = [ "default.target" ];
    description = "mDNS adguard advertisement";
    serviceConfig = {
      Type = "simple";
      ExecStart = ''${pkgs.avahi}/bin/avahi-publish -a -R adguard.local 192.168.64.228'';
    };
  };

  networking.firewall.allowedTCPPorts = [ 53 ];
  networking.firewall.allowedUDPPorts = [ 53 ];
  
  services.caddy.virtualHosts."adguard.local".extraConfig = ''
    reverse_proxy :3000
  '';
}
