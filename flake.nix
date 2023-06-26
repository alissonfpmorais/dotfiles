{
  description = "Chris' Jawns";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # openvpn-nixpkgs = {
    #   url = "github:NixOS/nixpkgs/53951c0c1444e500585205e8b2510270b2ad188f";
    #   flake = false;
    # };
    # rev53951c = {
    #   url = "github:NixOS/nixpkgs/53951c0c1444e500585205e8b2510270b2ad188f";
    #   flake = false;
    # };
    # rev7cf5cc = {
    #   url = "github:NixOS/nixpkgs/7cf5ccf1cdb2ba5f08f0ac29fc3d04b0b59a07e4";
    #   flake = false;
    # };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nix, home-manager }:
  let
    system = "x86_64-linux";
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
              (import ./overlays/openvpn.nix nixpkgs)
              (import ./overlays/networkmanager.nix nixpkgs)
              (import ./overlays/networkmanager-openvpn.nix nixpkgs)
            ];
          })
        ];
      };
    };
  };
}