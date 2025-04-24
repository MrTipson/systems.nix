inputs:
  with builtins; let
    isSystem = path: pathExists (./${path}/system.nix);
    hosts = filter isSystem (attrNames (readDir ./.));
    importHost = host: { name = host; value = import ./${host}/system.nix inputs; };
  in
    {
      nixosConfigurations = listToAttrs (map importHost hosts);
    }