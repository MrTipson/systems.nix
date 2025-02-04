{ pkgs, ... }:
{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      minipc = {
        host = "minipc";
        hostname = "192.168.64.228";
      };
    };
  };
}
