sources: {
  specialArgs = { inherit sources; };
  system = "x86_64-linux";
  modules = [
    ../default/configuration.nix
    ./configuration.nix
    ./hardware.nix
    "${sources.sops-nix}/modules/sops"
  ];
}
