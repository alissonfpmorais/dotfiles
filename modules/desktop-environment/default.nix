{ config, lib, ... }:

with lib;

let
  cfg = config.modules.de;
in
{
  imports = [
    ./gnome
    ./hyprland
  ];

  options.modules.de = {
    name = mkOption {
      type = with types; enum [ "gnome" "hyprland" ];
      default = "gnome";
      description = "Default desktop environment";
    };
  };

  config = {
    modules.de.gnome.enable = cfg.name == "gnome";
    modules.de.hyprland.enable = cfg.name == "hyprland";
  };
}