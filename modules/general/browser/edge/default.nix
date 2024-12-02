{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.general.browser.edge;
in
{
  options.modules.general.browser.edge = {
    enable = mkEnableOption "Enable edge browser";
  };

  config = mkIf cfg.enable {
    users.users.alissonfpmorais.packages = with pkgs; [
      microsoft-edge
    ];
  };
}