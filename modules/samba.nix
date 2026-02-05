{
  config,
  pkgs,
  lib,
  ...
}:
let
  # secrets file format:
  # username=<USERNAME>
  # domain=<DOMAIN>
  # password=<PASSWORD>
  mkMount = location: alias: remote: {
    options.custom.samba.${alias}.enable = lib.mkOption {
      default = true;
      description = "samba share ${alias}";
      type = lib.types.bool;
    };
    config = lib.mkIf config.custom.samba.${alias}.enable {
      fileSystems.${location} = {
        device = remote;
        fsType = "cifs";
        options = [
          "gid=samba"
          "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s"
          "dir_mode=0775"
          "file_mode=0664"
          "credentials=${config.sops.secrets.samba.path}"
        ];
      };
    };
  };
in
{
  imports = [
    (mkMount "/mnt/music" "music" "//kista.local/music")
  ];
  boot.supportedFilesystems.cifs = true;
  users.groups.samba = { };
  sops.secrets.samba = {
    mode = "0440";
    sopsFile = ../secrets/samba.env;
    format = "dotenv";
    owner = "root";
    group = "root";
  };
  environment.systemPackages = [ pkgs.cifs-utils ];
}
