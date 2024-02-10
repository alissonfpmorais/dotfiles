{
  description = "Chris' Jawns";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-openvpn.url = "github:NixOS/nixpkgs/7cf5ccf1cdb2ba5f08f0ac29fc3d04b0b59a07e4";
    # emacs-overlay.url  = "github:nix-community/emacs-overlay";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # outputs = { self, nixpkgs, nixpkgs-openvpn, nix, home-manager }@inputs:
  outputs = { nixpkgs, home-manager, ... }@args:
  let
    system = "x86_64-linux";
    inputs = args // { inherit system; };
  in
  {
    nixosConfigurations = import ./hosts inputs;
  };
}