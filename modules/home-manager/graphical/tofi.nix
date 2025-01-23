{ pkgs, lib, ... }:

let tofi-font-pkg = pkgs.nerd-fonts.fira-code;
  tofi-font = "${tofi-font-pkg}/share/fonts/truetype/NerdFonts/FiraCodeNerdFontMono-Retina.ttf";
in
{
  programs.tofi = {
    enable = true;
    settings = {
      background-color = lib.mkDefault "#000A";
      border-width = 0;
      font = lib.mkDefault tofi-font;
      height = "100%";
      num-results = 5;
      outline-width = 0;
      padding-left = "35%";
      padding-top = "35%";
      result-spacing = 25;
      width = "100%";
    };
  };
  home.packages = [ tofi-font-pkg pkgs.fd ];
  # Workaround for tofi sometimes not updating cache
  home.activation.tofi = lib.hm.dag.entryAfter ["writeBoundary"] ''rm -f ~/.cache/tofi-drun'';
}
