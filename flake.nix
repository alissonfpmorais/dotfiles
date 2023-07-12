{
  description = "Chris' Jawns";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-openvpn.url = "github:NixOS/nixpkgs/7cf5ccf1cdb2ba5f08f0ac29fc3d04b0b59a07e4";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # outputs = { self, nixpkgs, nixpkgs-openvpn, nix, home-manager }@inputs:
  outputs = { nixpkgs, home-manager, ... }@inputs:
  let
    system = "x86_64-linux";

    stdConfig = ./hosts/laptop/configuration.nix;
    overlays = import ./overlays (inputs // { inherit system; });
  in
  {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        # extraArgs = {};
        modules = [
          stdConfig
          home-manager.nixosModules.home-manager {
            home-manager.useUserPackages = true;
            home-manager.users.alissonfpmorais = import ./hosts/laptop/home.nix;
          }
          overlays
        ];
      };
    };
  };
}