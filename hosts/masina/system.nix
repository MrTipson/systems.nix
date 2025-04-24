{ self, nixpkgs, ... }@inputs: nixpkgs.lib.nixosSystem {
  specialArgs = { inherit inputs; };
  modules = [
    ./configuration.nix
    inputs.sops-nix.nixosModules.sops
  ];
}