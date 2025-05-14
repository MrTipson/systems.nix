{ self, nixpkgs, ... }@inputs: rec {
  specialArgs = { inherit inputs; };
  system = "x86_64-linux";
  modules = [
    ./configuration.nix
  ];
}