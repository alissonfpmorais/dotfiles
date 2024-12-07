{ ags, home-manager, hyprland, nixpkgs, system, ... }:
let
  modulesCfg = ../modules;
  nixCfg = systemCfg: hwCfg:
    nixpkgs.lib.nixosSystem {
      inherit system;
      extraArgs = {
        ags = ags;
        hyprland = hyprland;
      };
      modules = [
        hwCfg
        modulesCfg
        systemCfg
        home-manager.nixosModules.home-manager {
          home-manager.useUserPackages = true;
          home-manager.users.alissonfpmorais = { lib, pkgs, ... }: { home.stateVersion = "22.11"; };
        }
      ];
    };
in
{
  corning = nixCfg ./corning/configuration.nix ./corning/hardware-configuration.nix;
}