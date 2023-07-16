{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.general.browser.brave;
in
{
  options.modules.general.browser.brave = {
    enable = mkEnableOption "Enable brave browser";
  };

  config = mkIf cfg.enable {
    users.users.alissonfpmorais.packages = with pkgs; [
      brave
    ];
  };
}