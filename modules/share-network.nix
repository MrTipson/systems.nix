{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (config.networking.share) from to;
in
{
  options.networking.share = {
    from = lib.mkOption {
      default = null;
      example = "wlo1";
      description = "Connection source";
      type = lib.types.nullOr lib.types.str;
    };
    to = lib.mkOption {
      default = null;
      example = "enp1s0";
      description = "Connection sink";
      type = lib.types.nullOr lib.types.str;
    };
  };

  config = lib.mkIf (from != null && to != null) {
    # Set a static IP on the "downstream" interface
    networking.interfaces.${to} = {
      useDHCP = false;
      ipv4.addresses = [
        {
          address = "10.0.0.1";
          prefixLength = 24;
        }
      ];
    };
    networking.firewall.extraCommands = ''
      # Set up SNAT on packets going from downstream to the wider internet
      iptables -t nat -A POSTROUTING -o ${from} -j MASQUERADE

      # Accept all connections from downstream. May not be necessary
      iptables -A INPUT -i ${to} -j ACCEPT
    '';
    # Run a DHCP server on the downstream interface
    services.kea.dhcp4 = {
      enable = true;
      settings = {
        interfaces-config.interfaces = [ to ];
        lease-database = {
          name = "/var/lib/kea/dhcp4.leases";
          persist = true;
          type = "memfile";
        };
        rebind-timer = 2000;
        renew-timer = 1000;
        subnet4 = [
          {
            id = 1;
            pools = [
              {
                pool = "10.0.0.2 - 10.0.0.255";
              }
            ];
            subnet = "10.0.0.1/24";
          }
        ];
        valid-lifetime = 4000;
        option-data = [
          {
            name = "routers";
            data = "10.0.0.1";
          }
        ];
      };
    };
  };
}
