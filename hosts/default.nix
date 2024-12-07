{
  home-manager,
  nixpkgs,
  system,
  ...
}@inputs:
let
  modulesCfg = ../modules;
  nixCfg =
    systemCfg: hwCfg:
    nixpkgs.lib.nixosSystem {
      inherit system;
      extraArgs = inputs;
      modules = [
        hwCfg
        modulesCfg
        systemCfg
        home-manager.nixosModules.home-manager
        {
          home-manager.useUserPackages = true;
          home-manager.users.alissonfpmorais =
            { ... }:
            {
              home.stateVersion = "22.11";
            };
        }
      ];
    };
in
{
  corning = nixCfg ./corning/configuration.nix ./corning/hardware-configuration.nix;
}
