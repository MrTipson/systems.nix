inputs:
  with builtins; let
    nixosSystem = inputs.nixpkgs.lib.nixosSystem;
    isSystem = path: pathExists (./${path}/system.nix);
    hosts = filter isSystem (attrNames (readDir ./.));
    importHost = host:
      let
        config = import ./${host}/system.nix inputs;
        vmmodule = args: { users.users.root.initialPassword = ""; };
      in 
        if match ".*vm$" host == null
        then
          {
            ${host} = nixosSystem config;
            "${host}vm" = nixosSystem (config // { modules = config.modules ++ [ vmmodule ]; });
          }
        else
          {
            ${host} = nixosSystem config;
          };
  in
    {
      nixosConfigurations = builtins.foldl' (acc: x: acc // x) {} (map importHost hosts);
    }