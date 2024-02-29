{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.general.explorer.xplr;
in
{
  options.modules.general.explorer.xplr = {
    enable = mkEnableOption "Enable xplr tui file manager";
  };

  config = mkIf cfg.enable {
    users.users.alissonfpmorais.packages = with pkgs; [
      xplr
    ];
  };
}
