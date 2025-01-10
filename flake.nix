{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # flake-programs-sqlite = {
    #   url = "github:wamserma/flake-programs-sqlite";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # anytype-heart-grpc = {
    #   url = "path:/home/tipson/devel/nix-anytype-heart";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };
  outputs =
    { self, nixpkgs, ... }@inputs:
    {
      nixosConfigurations.nospit = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        system = "x86_64-linux";
        modules = [
          ./hosts/nospit/configuration.nix
          inputs.home-manager.nixosModules.default
          inputs.sops-nix.nixosModules.sops
          # inputs.flake-programs-sqlite.nixosModules.programs-sqlite
          # inputs.anytype-heart-grpc.nixosModules.anytype-heart-grpc
        ];
      };
      nixosConfigurations.masina = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        system = "x86_64-linux";
        modules = [
          ./hosts/masina/configuration.nix
          inputs.home-manager.nixosModules.default
          inputs.sops-nix.nixosModules.sops
        ];
      };
    };
}
