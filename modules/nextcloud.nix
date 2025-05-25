{
  pkgs,
  lib,
  config,
  ...
}: let 
  advertise = import ./_avahi.nix pkgs;
in {
  sops.secrets.default-admin-pass = {
    mode = "0440";
    sopsFile = ../secrets/nextcloud.yaml;
    owner = "nextcloud";
    group = "nextcloud";
    key = "default-admin-pass";
  };

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud31;
    hostName = "localhost";
    config.adminpassFile = config.sops.secrets.default-admin-pass.path;
    config.dbtype = "sqlite";
    settings = {
      trusted_domains = [ "nextcloud.local" ];
    };
    extraApps = {
      inherit (config.services.nextcloud.package.packages.apps) contacts calendar tasks onlyoffice;
    };
  };

  services.nginx.virtualHosts."${config.services.nextcloud.hostName}".listen = [ {
    addr = "127.0.0.1";
    port = 3001;
  } ];

  systemd.services.mDNS-nextcloud = lib.mkIf config.services.avahi.enable
    (advertise "nextcloud" [ "nextcloud.service" ]);

  services.caddy.virtualHosts."nextcloud.local".extraConfig = ''
    reverse_proxy http://localhost:3001
  '';
}
