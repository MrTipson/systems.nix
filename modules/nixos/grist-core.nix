{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.services.grist-core = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable grist service";
    };
    package = lib.mkOption {
      type = lib.types.anything;
    };
  };

  config = lib.mkIf (config.services.grist-core.enable) {
    systemd.services.grist-core = {
      enable = true;
      description = "Grist service";
      after = [ "network.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = ''${pkgs.yarn}/bin/yarn --offline start:prod'';
        WorkingDirectory = "${config.services.grist-core.package}";
        Environment = ''
          PYTHON_VERSION_ON_CREATION=3 \
          GRIST_HOST=0.0.0.0 \
          PORT=80 \
          GRIST_SINGLE_PORT=true
        '';
      };
    };
  };
}
