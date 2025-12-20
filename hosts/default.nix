sources:
with builtins;
let
  nixosSystem = import "${sources.nixpkgs}/nixos/lib/eval-config.nix";
  isSystem = path: pathExists (./${path}/system.nix);
  hosts = filter isSystem (attrNames (readDir ./.));
  importHost =
    host:
    let
      config = import ./${host}/system.nix sources;
      vmmodule = args: { users.users.root.initialPassword = ""; };
    in
    if match ".*vm$" host == null then
      {
        ${host} = nixosSystem config;
        "${host}vm" = nixosSystem (config // { modules = config.modules ++ [ vmmodule ]; });
      }
    else
      {
        ${host} = nixosSystem config;
      };
in
builtins.foldl' (acc: x: acc // x) { } (map importHost hosts)
