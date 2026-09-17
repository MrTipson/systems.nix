# https://kldload.com/tutorials/zfs-encryption
# zfs create \
#  -o encryption=aes-256-gcm \
#  -o keylocation=prompt \
#  -o keyformat=passphrase \
#  storage/zaklad
#
# zfs get encryption,keyformat,keylocation,keystatus storage/zaklad
{ sources, config, pkgs, lib, ...}:
let
  cfg = config.services.copyparty;
  ensureDirs = [ "/storage/zaklad/ananas" ];
in
{
  imports = [ "${sources.copyparty}/contrib/nixos/modules/copyparty.nix" ];

  sops.secrets.copyparty = {
    mode = "0440";
    sopsFile = ../secrets/copyparty.conf;
    format = "binary";
    owner = cfg.user;
    group = cfg.group;
  };

  services.copyparty.enable = true;
  systemd.services.copyparty.serviceConfig = {
    ExecStart = lib.mkForce "${lib.getExe cfg.package} -c \${CREDENTIALS_DIRECTORY}/config";
    LoadCredential = "config:${config.sops.secrets.copyparty.path}";
    BindPaths = ensureDirs;
  };
  custom.persist.directories = [ "/var/lib/copyparty" ];
  networking.firewall.allowedTCPPorts = [ 3923 ];

  systemd.tmpfiles.settings."copyparty" = lib.listToAttrs (map (path: lib.nameValuePair path {
    d = {
      #: in front of things means it wont change it if the directory already exists.
      group = ":${cfg.group}";
      user = ":${cfg.user}";
      mode = ":755";
    };
  }) ensureDirs);
}
