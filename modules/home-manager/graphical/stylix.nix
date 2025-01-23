{ pkgs, ... }:
{
  stylix = {
    enable = true;
    image = ./museum.png;
    opacity = {
      applications = 0.9;
      desktop = 0.8;
      terminal = 0.8;
      popups = 1.0;
    };
    cursor = {
      package = pkgs.catppuccin-cursors.mochaDark;
      name = "catppuccin-mocha-dark-cursors";
      size = 16;
    };
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
  };
}
