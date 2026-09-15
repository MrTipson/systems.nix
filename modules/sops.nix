{ sources, config, pkgs, ... }:
{
  imports = [ "${sources.sops-nix}/modules/sops" ];

  sops = {
    defaultSopsFormat = "yaml";
    age.keyFile = "/etc/sops/age/keys.txt";
  };
  custom.persist.files = [ "/etc/sops/age/keys.txt" ];

  environment.systemPackages = with pkgs; [
    sops
  ];
}
