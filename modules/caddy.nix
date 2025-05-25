{ pkgs, lib, config, ... }: let 
  advertise = import ./_avahi.nix pkgs;
in {
  services.caddy.enable = true;

  systemd.services.mDNS-caddy-ca = lib.mkIf config.services.avahi.enable 
    (advertise "ca" [ "caddy.service" ]);
  
  services.caddy.virtualHosts."ca.local".extraConfig = lib.mkIf config.services.avahi.enable ''
    header Content-Disposition "attachment"
    redir / /root.crt
    file_server {
      root /var/lib/caddy/.local/share/caddy/pki/authorities/local/
      hide *.key
    }
  '';
}
