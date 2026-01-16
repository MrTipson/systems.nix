{
  lib,
  pkgs,
  config,
  ...
}:
{
  users.groups.servarr = { };
  users.users.prowlarr = {
    isSystemUser = true;
    description = "User for prowlarr";
    group = "servarr";
  };
  systemd.services.prowlarr = {
    description = "Prowlarr";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "simple";
      User = "prowlarr";
      Group = "servarr";
      ExecStart = "${lib.getExe pkgs.prowlarr} -nobrowser -data=/storage/service/arr/prowlarr";
      Restart = "on-failure";
    };
  };
  systemd.tmpfiles.settings."prowlarr"."/storage/service/arr/prowlarr"."d" = {
    mode = "700";
    user = "prowlarr";
    group = "servarr";
  };
  systemd.tmpfiles.settings."torrent-folder"."/storage/media/Torrents"."L+" = {
    inherit (config.services.qbittorrent) user;
    group = "servarr";
    argument = "/storage/service/qBittorrent/downloads";
  };

  users.users.jellyseerr = {
    isSystemUser = true;
    description = "User for jellyseerr";
    group = "servarr";
  };
  systemd.services.jellyseerr = {
    description = "Jellyseerr";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    environment = {
      PORT = toString 5055;
      CONFIG_DIRECTORY = "/storage/service/arr/jellyseerr";
    };
    serviceConfig = {
      Type = "simple";
      User = "jellyseerr";
      Group = "servarr";
      ExecStart = lib.getExe pkgs.jellyseerr;
      Restart = "on-failure";
    };
  };
  systemd.tmpfiles.settings."jellyseerr"."/storage/service/arr/jellyseerr"."d" = {
    mode = "700";
    user = "jellyseerr";
    group = "servarr";
  };

  networking.firewall.allowedTCPPorts = [
    9696 # prowlarr
    5055 # jellyseerr
  ];

  services.sonarr = {
    enable = true;
    group = "servarr";
    openFirewall = true; # default is 8989
    dataDir = "/storage/service/arr/sonarr";
  };

  services.radarr = {
    enable = true;
    group = "servarr";
    openFirewall = true; # default is 7878
    dataDir = "/storage/service/arr/radarr";
  };

  services.flaresolverr = {
    enable = true;
    openFirewall = true; # default is 8191
  };

  services.qbittorrent = {
    enable = true;
    group = "servarr";
    openFirewall = true;
    webuiPort = 9678;
    extraArgs = [ "--confirm-legal-notice" ];
    profileDir = "/storage/service"; # qBittorrent directory is created inside
  };
}
