{
  description = "Chris' Jawns";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-rev7cf5cc.url = "github:NixOS/nixpkgs/7cf5ccf1cdb2ba5f08f0ac29fc3d04b0b59a07e4";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-rev7cf5cc, nix, home-manager }:
  let
    system = "x86_64-linux";
    overlay-rev7cf5cc = final: prev: {
      rev7cf5cc = import nixpkgs-rev7cf5cc {
        inherit system;
        config.allowUnfree = true;
      };
    };
  in
  {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        extraArgs = {};
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager {
            home-manager.useUserPackages = true;
            home-manager.users.alissonfpmorais = import ./home.nix;
          }
          ({...}: {
            nixpkgs.overlays = [
              overlay-rev7cf5cc
            ];
          })
        ];
      };
    };
  };
}