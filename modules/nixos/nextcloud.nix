{
  pkgs,
  lib,
  config,
  ...
}:
{
  sops.secrets.default-admin-pass = {
    mode = "0440";
    sopsFile = ../../secrets/nextcloud.yaml;
    owner = "nextcloud";
    group = "nextcloud";
    key = "default-admin-pass";
  };

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud30;
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

  systemd.services.mDNS-nextcloud = lib.mkIf config.services.avahi.enable {
    enable = true;
    after = [ "nextcloud.service" ];
    wantedBy = [ "default.target" ];
    description = "mDNS adguard advertisement";
    serviceConfig = {
      Type = "simple";
      ExecStart = ''${pkgs.avahi}/bin/avahi-publish -a -R nextcloud.local 192.168.64.228'';
    };
  };

  services.caddy.virtualHosts."nextcloud.local".extraConfig = ''
    reverse_proxy http://localhost:3001
  '';
  # services.avahi.extraServiceFiles.nextcloud = ''
  #   <?xml version="1.0" standalone="no"?>
  #   <!DOCTYPE service-group SYSTEM "avahi-service.dtd">
  #   <service-group>
  #     <name replace-wildcards="yes">nextcloud</name>
  #     <service>
  #       <type>_http._tcp</type>
  #       <port>80</port>
  #     </service>
  #   </service-group>
  # '';
}
