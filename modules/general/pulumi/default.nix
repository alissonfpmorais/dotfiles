{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.general.pulumi;
in
{
  options.modules.general.pulumi = {
    enable = mkEnableOption "Enable Pulumi cli";
  };

  config = mkIf cfg.enable {
    users.users.alissonfpmorais.packages = with pkgs; [
      pulumi-bin
    ];
  };
}