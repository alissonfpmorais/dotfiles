{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.editors.godot;
in
{
  options.modules.editors.godot = {
    enable = mkEnableOption "Godot Game Engine";
  };

  config = mkIf cfg.enable {
    users.users.alissonfpmorais.packages = with pkgs; [
      godot
    ];
  };
}
