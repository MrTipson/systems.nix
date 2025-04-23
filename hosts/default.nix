inputs:
  with builtins; let
    isSystem = path: pathExists (./${path}/system.nix);
    hosts = filter isSystem (attrNames (readDir ./.));
    importHost = host: { name = host; value = import ./${host}/system.nix inputs; };
    hasHM = host: pathExists (./${host}/home-manager/default.nix);
    importHostHM = host: { name = host; value = import ./${host}/home-manager/default.nix; };
  in
    {
      nixosConfigurations = listToAttrs (map importHost hosts);
      homeManagerModules = listToAttrs (map importHostHM (filter hasHM hosts));
    }