{
  description = "alissonfpmorais dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # outputs = { self, nixpkgs, nixpkgs-openvpn, nix, home-manager, hyprland }@inputs:
  outputs = { nixpkgs, home-manager, ... }@args:
    let
      system = "x86_64-linux";
      inputs = args // { inherit system; };
    in
    {
      nixosConfigurations = import ./hosts inputs;
    };
}
