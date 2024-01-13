{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.general.postman;
in
{
  options.modules.general.postman = {
    enable = mkEnableOption "Enable Postman cli";
  };

  config = mkIf cfg.enable {
    users.users.alissonfpmorais.packages = with pkgs; [
      postman
    ];
  };
}