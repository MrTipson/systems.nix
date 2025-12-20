sources: {
  specialArgs = { inherit sources; };
  system = "x86_64-linux";
  modules = [
    ./configuration.nix
    "${sources.sops-nix}/modules/sops"
  ];
}
