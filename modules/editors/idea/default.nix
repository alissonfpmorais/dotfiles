{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.editors.idea;
in
{
  options.modules.editors.idea = {
    enable = mkEnableOption "Enable JetBrains IDEA editor";
  };

  config = mkIf cfg.enable {
    users.users.alissonfpmorais.packages = with pkgs; [
      jetbrains.idea-ultimate
    ];
  };
}