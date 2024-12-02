{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.general.ngrok;
in
{
  options.modules.general.ngrok = {
    enable = mkEnableOption "Enable ngrok cli";
  };

  config = mkIf cfg.enable {
    users.users.alissonfpmorais.packages = with pkgs; [
      ngrok
    ];
  };
}