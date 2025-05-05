{ self, nixpkgs, ... }@inputs: {
  specialArgs = { inherit inputs system; };
  system = "x86_64-linux";
  modules = [
    ./configuration.nix
    inputs.sops-nix.nixosModules.sops
  ];
}