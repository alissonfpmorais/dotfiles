{ home-manager, nixpkgs, system, ... }@inputs:
let
  hwConfig = ./hardware-configuration.nix;
  stdConfig = ./configuration.nix;
  overlays = import ./overlays.nix inputs;
in
nixpkgs.lib.nixosSystem {
  inherit system;
  # extraArgs = {};
  modules = [
    hwConfig
    stdConfig
    home-manager.nixosModules.home-manager {
      home-manager.useUserPackages = true;
      home-manager.users.alissonfpmorais = import ./home.nix;
    }
    overlays
  ];
}
