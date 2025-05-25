{ config, pkgs, lib, ... }: let
  advertise = import ./_avahi.nix pkgs;
in {
  services.adguardhome = {
    enable = true;
    mutableSettings = false;
    settings = {
      dns.bootstrap_dns = [ "1.1.1.1" ];
    };
  };

  systemd.services.mDNS-adguard = lib.mkIf config.services.avahi.enable 
    (advertise "adguard" [ "adguardhome.service" ]);

  networking.firewall.allowedTCPPorts = [ 53 ];
  networking.firewall.allowedUDPPorts = [ 53 ];
  
  services.caddy.virtualHosts."adguard.local".extraConfig = ''
    reverse_proxy :3000
  '';
}
