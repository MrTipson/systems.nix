pkgs: service-name: dependencies:
  let
    publish-local = pkgs.writeShellApplication {
      name = "mDNS-publisher";
      runtimeInputs = with pkgs; [ bash nettools gnugrep avahi ];
      text = ''ifconfig | grep -oE "192.168[0-9.]+" | head -n1 | xargs avahi-publish -a -R "$1"'';
    };
  in
    {
      enable = true;
      after = dependencies;
      wantedBy = [ "default.target" ];
      description = "mDNS ${service-name} advertisement";
      serviceConfig = {
        Type = "simple";
        ExecStart = ''${publish-local}/bin/mDNS-publisher ${service-name}.local'';
      };
    }
