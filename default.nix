{
  overrides ? { },
  sources ? (import ./npins // overrides),
  ...
}:
{
  inherit sources;
  outPath = ./.;

  nixosConfigurations = import ./hosts sources;
  nixosModules = import ./modules;
}
