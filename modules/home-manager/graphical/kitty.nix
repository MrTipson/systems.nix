{ pkgs, lib, ... }:
{
  programs.kitty = {
    enable = true;
    settings = {
      background_opacity = lib.mkDefault 0.8;
    };
  };
}
