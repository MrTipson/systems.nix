# https://discourse.nixos.org/t/nixpkgs-flake-input-version/64116/16
# This module makes it so that flakes on this machine may reference registry entries in the lockfile
# This is useful so that a single nixpkgs instance can be shared by many flakes
# For example, a standalone home-manager installation
{ inputs, pkgs, config, ... }: {
  nix.registry."nixpkgs".flake = inputs.nixpkgs;
  nix.package = pkgs.nix.overrideAttrs (old: {
    patches = old.patches ++ [ ./registry.patch ];
  });
}