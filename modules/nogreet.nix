{ pkgs, lib, config, ... }:
{
  systemd.defaultUnit = "graphical.target";
}
