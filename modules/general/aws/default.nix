{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.general.aws;
in
{
  options.modules.general.aws = {
    enable = mkEnableOption "Enable AWS cli";
  };

  config = mkIf cfg.enable {
    users.users.alissonfpmorais.packages = with pkgs; [
      awscli
    ];
  };
}