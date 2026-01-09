{ sources, config, pkgs, ... }:
{
  imports = [ "${sources.sops-nix}/modules/sops" ];

  sops = {
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/tipson/.config/sops/age/keys.txt";
  };

  environment.systemPackages = with pkgs; [
    sops
  ];
}
