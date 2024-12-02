{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.general.browser.vivaldi;
in
{
  options.modules.general.browser.vivaldi = {
    enable = mkEnableOption "Enable vivaldi browser";
  };

  config = mkIf cfg.enable {
    users.users.alissonfpmorais.packages = with pkgs; [
      vivaldi
    ];
  };
}