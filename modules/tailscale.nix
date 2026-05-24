{ pkgs, lib, config, ... }:
{
  # sudo tailscale up --login-server <url>
  services.tailscale.enable = true;
  custom.persist.directories = [ "/var/lib/tailscale" ];
}
