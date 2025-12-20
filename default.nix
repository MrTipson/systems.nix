{
  overrides ? {
    multiseat-nix.outPath = "/home/tipson/Dev/multiseat-nix";
  },
  sources ? (import ./npins // overrides),
  ...
}:
{
  inherit sources;
  outPath = ./.;

  nixosConfigurations = import ./hosts sources;
  nixosModules = import ./modules;
}
