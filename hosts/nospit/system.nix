{ self, nixpkgs, ... }@inputs: {
  specialArgs = { inherit inputs; };
  modules = [
    ./configuration.nix
    inputs.sops-nix.nixosModules.sops
  ];
}