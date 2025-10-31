{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    banked-rank-it = {
      url = "github:mrtipson/banked-rank-it";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    tipson-software = {
      url = "github:mrtipson/software.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dummy-session = {
      url = "github:mrtipson/dummy-session";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs: import ./hosts inputs;
}
