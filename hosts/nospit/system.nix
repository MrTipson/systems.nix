{ self, nixpkgs, ... }@inputs: nixpkgs.lib.nixosSystem {
  specialArgs = { 
    inherit inputs;
    myconfig = {
      graphical = false;
    };
  };
  system = "x86_64-linux";
  modules = [
    ./configuration.nix
    inputs.home-manager.nixosModules.default
    inputs.sops-nix.nixosModules.sops
  ];
}