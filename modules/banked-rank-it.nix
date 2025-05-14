{ pkgs, lib, config, inputs, ... }:
{
  sops.secrets.bank-it-bot = {
    mode = "0440";
    sopsFile = ../secrets/banked-rank-it.env;
    format = "dotenv";
    owner = "bread";
    group = "bread";
  };

  users.users.bread = {
    isNormalUser = true;
    description = "User for bank it bot";
    group = "bread";
  };
  users.groups.bread = { };

  systemd.services.banked-rank-it = {
    enable = true;
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    description = "Discord bot for Bank It Enjoyers";
    serviceConfig = {
      User = "bread";
      Group = "bread";
      WorkingDirectory = "/home/bread";
      Type = "simple";
      EnvironmentFile = config.sops.secrets.bank-it-bot.path;
      ExecStart = "${inputs.banked-rank-it.packages.${pkgs.system}.default}/bin/banked-rank-it";
    };
  };
}
