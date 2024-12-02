{ home-manager, hyprland, nixpkgs, system, ... }:
let
  modulesCfg = ../modules;
  nixCfg = systemCfg: hwCfg: homeCfg:
    nixpkgs.lib.nixosSystem {
      inherit system;
      extraArgs = { hyprland = hyprland; };
      modules = [
        hwCfg
        modulesCfg
        systemCfg
        home-manager.nixosModules.home-manager {
          home-manager.useUserPackages = true;
          home-manager.users.alissonfpmorais = import homeCfg;
        }
      ];
    };
in
{
  corning = nixCfg ./corning/configuration.nix ./corning/hardware-configuration.nix ./corning/home.nix;
}