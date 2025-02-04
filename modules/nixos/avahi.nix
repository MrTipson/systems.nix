{ pkgs, lib, ... }:
{
  # environment.systemPackages = [ pkgs.nssmdns ];

  services.avahi = {
    enable = true;
    publish.enable = true;
  };
}
