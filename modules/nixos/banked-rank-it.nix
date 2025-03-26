{ pkgs, lib, config, ... }:
{
  sops.secrets.bank-it-bot = {
    mode = "0440";
    sopsFile = ../../secrets/banked-rank-it.yaml;
    owner = "bread";
    group = "bread";
    key = "token";
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
      ExecStart =
        let flake = builtins.getFlake "github:mrtipson/banked-rank-it/6beace3f383c5c91cda0b72c94abed2046204478";
            package = flake.packages."x86_64-linux".default;
            token-path = config.sops.secrets.bank-it-bot.path;
        in ''${pkgs.bash}/bin/bash -c "TOKEN=$(cat ${token-path}) ${package}/bin/banked-rank-it"'';
    };
    environment = {
      MESSAGE_ID = "1354078262401175625";
      CHANNEL_ID = "1354076768256135251";
    };
  };
}
