{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.general.zoxide;
in
{
  options.modules.general.zoxide = {
    enable = mkEnableOption "Zoxide smart cd";
  };

  config = mkIf cfg.enable {
    home-manager.users.alissonfpmorais = {
      programs.zoxide = {
        enable = true;
      };
    };
  };
}