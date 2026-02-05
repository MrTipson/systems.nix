# Adapted from https://github.com/somasis/puter/blob/main/modules/nixos/npins.nix
{
  sources,
  pkgs,
  lib,
  ...
}:
let
  sources' = builtins.removeAttrs sources [ "__functor" ];
in
{
  environment = {
    systemPackages = [ pkgs.npins ];
    etc.npins.source = pkgs.linkFarm "npins-sources" (
      lib.mapAttrsToList (name: src: {
        inherit name;
        path = src.outPath;
      }) sources'
    );
  };

  system.nixos = {
    revision = lib.trivial.revisionWithDefault (
      builtins.replaceStrings [ "nixos-" "nixpkgs-" ] [ "" "" ] (
        builtins.baseNameOf (builtins.dirOf sources.nixpkgs.sourceInfo.url)
      )
    );

    versionSuffix = ".${lib.trivial.versionSuffix}";
  };

  # Disable all points of dependency pulling other than npins.
  nix = {
    channel.enable = false;

    # Set $NIX_PATH to our sources in /etc/npins.
    nixPath = lib.mkForce (lib.mapAttrsToList (n: _: "${n}=/etc/npins/${n}") sources');

    # Translate npins sources to Flakes in the system registry.
    registry = lib.mkForce (
      lib.mapAttrs (n: v: {
        to = {
          type = "path";
          path = "${v}";
        };
      }) sources'
    );
  };

}
