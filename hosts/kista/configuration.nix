{ config, pkgs, ... }:
{
  imports = with import ../../modules; [
    avahi
    icecast
    impermanence
    sailing
    sops
    tailscale
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "kista";
    hostId = "74dbcdb0"; # needed for zfs
    networkmanager.enable = true;
    nameservers = [ "1.1.1.1" ];
  };

  # cloudflared tunnel create <name>
  # sops encrypt ~/.cloudflared/<uuid>.json > secrets/tunnel-<name>.json
  sops.secrets.tunnel-kista = {
    sopsFile = ../../secrets/tunnel-kista.json;
    format = "json";
    key = "";
  };
  sops.secrets.cloudflared-creds = {
    format = "binary";
    sopsFile = ../../secrets/cloudflared-creds;
  };
  services.cloudflared = {
    enable = true;
    certificateFile = "${config.sops.secrets.cloudflared-creds.path}";
    tunnels = {
      # if configuration gets borked and tunnel starts ignoring updates, you need to create new one
      "2069af88-b608-417f-8c92-15d6286a4e22" = {
        credentialsFile = "${config.sops.secrets.tunnel-kista.path}";
        ingress = {
          "icecast.tipson.xyz" = {
            service = "http://localhost:8000";
            path = "/main\\.opus$";
          };
        };
        default = "http_status:404";
      };
    };
  };

  # impermanence stubs users
  custom.users = {
    tipson = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };
  };

  system.stateVersion = "25.11"; # don't change
}
