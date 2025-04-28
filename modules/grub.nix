# Leaving this here for posterity:
# I was never able to get the graphical emulation quite working but this at least compiles.
# The sdl part might not be needed at all
# Also nice to have a note of how to inspect stdenv.mkDerivation
# nix-shell -E "(import <nixpkgs> {}).grub2.overrideAttrs (a:
# {
#   configureFlags = a.configureFlags ++ [\"--with-platform=emu\"  \"--target=x86_64\" \"--enable-grub-emu-sdl2\"];
#   buildInputs = a.buildInputs ++ [ (import <nixpkgs> {}).SDL2 ];
# })
# eval "${unpackPhase:-unpackPhase}"
# cd $sourceRoot
# eval "${patchPhase:-patchPhase}"
# make widthspec.h ascii.h
# eval "${configurePhase:-configurePhase}"
# eval "${buildPhase:-buildPhase}"
# grub-core/grub-emu
{ pkgs, lib, config, ... }:
{
  boot.loader.grub = 
  {
    device = "nodev";
    splashImage = null;
    efiSupport = true;
    gfxmodeEfi = "1024x768"; # 1920x1080 seems to mess with font scaling so i'd rather not touch it
    theme = pkgs.stdenv.mkDerivation {
      name = "mrtipson's grub theme";

      nativeBuildInputs = [ pkgs.grub2 ];
      # Barlow Semi Condensed Light 16
      src = pkgs.fetchurl {
        url = "https://github.com/google/fonts/raw/9c93ba3639f2d4bff91f5e7c0ede6e40e92fca79/ofl/barlowsemicondensed/BarlowSemiCondensed-Light.ttf";
        hash = "sha256-zEoa09aOwBenmwmCKOdsci7ZLl55GXhGfHZDcYbyKgM=";
      }; 

      unpackPhase = "true";
      buildPhase = ''grub-mkfont -d 6 -c 18 -o converted.pf2 $src'';
      installPhase = ''
        mkdir -p $out
        cp converted.pf2 $out
        cp ${./grub-theme}/* $out
      '';
    };
  };
}
