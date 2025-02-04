{ config, pkgs, ...}: 
{ 
  sops = {
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/tipson/.config/sops/age/keys.txt";
  };
}