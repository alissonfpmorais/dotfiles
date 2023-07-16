{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.general.browser.firefox;
in
{
  options.modules.general.browser.firefox = {
    enable = mkEnableOption "Enable firefox browser";
  };

  config = mkIf cfg.enable {
    users.users.alissonfpmorais.packages = with pkgs; [
      firefox
    ];
  };
}