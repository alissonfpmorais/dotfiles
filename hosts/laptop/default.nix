{ home-manager, hyprland, nixpkgs, nixvim, system, ... }@inputs:
let
  hwConfig = ./hardware-configuration.nix;
  modulesConfig = ../../modules;
  stdConfig = ./configuration.nix;
  overlays = import ./overlays.nix inputs;
in
nixpkgs.lib.nixosSystem {
  inherit system;
  extraArgs = {
    hyprland = hyprland;
    nixvim = nixvim;
  };
  modules = [
    hwConfig
    modulesConfig
    stdConfig
    home-manager.nixosModules.home-manager
    {
      home-manager.useUserPackages = true;
      home-manager.users.alissonfpmorais = import ./home.nix;
    }
    overlays
  ];
}
