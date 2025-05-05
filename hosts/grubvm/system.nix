{ self, nixpkgs, ... }@inputs: {
  specialArgs = { inherit inputs; };
  system = "x86_64-linux";
  modules = [
    ./configuration.nix
  ];
}