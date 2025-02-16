{ pkgs, lib, config, ... }:
{
  services.caddy.enable = true;


  systemd.services.mDNS-caddy-ca = lib.mkIf config.services.avahi.enable {
    enable = true;
    after = [ "caddy.service" ];
    wantedBy = [ "default.target" ];
    description = "mDNS caddy CA advertisement";
    serviceConfig = {
      Type = "simple";
      ExecStart = ''${pkgs.avahi}/bin/avahi-publish -a -R ca.local 192.168.64.228'';
    };
  };
  
  services.caddy.virtualHosts."ca.local".extraConfig = lib.mkIf config.services.avahi.enable ''
    header Content-Disposition "attachment"
    redir / /root.crt
    file_server {
      root /var/lib/caddy/.local/share/caddy/pki/authorities/local/
      hide *.key
    }
  '';
}
