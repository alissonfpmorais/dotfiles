{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.editors.rider;
in
{
  options.modules.editors.rider = {
    enable = mkEnableOption "Enable JetBrains Rider editor";
  };

  config = mkIf cfg.enable {
    users.users.alissonfpmorais.packages = with pkgs; [
      jetbrains.rider
    ];
  };
}