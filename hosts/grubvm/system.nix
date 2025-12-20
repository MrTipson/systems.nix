sources: {
  specialArgs = { inherit sources; };
  system = "x86_64-linux";
  modules = [
    ./configuration.nix
  ];
}
