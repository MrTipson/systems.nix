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
      trusted_domains = [ "nospit.local" ];
    };
    extraApps = {
      inherit (config.services.nextcloud.package.packages.apps) contacts calendar tasks onlyoffice;
    };
  };

  services.avahi.extraServiceFiles = {
    nextcloud = ''
      <?xml version="1.0" standalone="no"?>
      <!DOCTYPE service-group SYSTEM "avahi-service.dtd">
      <service-group>
        <name replace-wildcards="yes">nextcloud</name>
        <service>
          <type>_http._tcp</type>
          <port>80</port>
          <txt-record>path=/nextcloud</txt-record>
        </service>
      </service-group>
    '';
  };
}
