{
  description = "alissonfpmorais dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    ags.url = "github:aylur/ags";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # outputs = { self, nixpkgs, nix, home-manager, hyprland, ags, nixvim }@inputs:
  outputs =
    { ... }@args:
    let
      system = "x86_64-linux";
      inputs = args // {
        inherit system;
      };
    in
    {
      nixosConfigurations = import ./hosts inputs;
    };
}
