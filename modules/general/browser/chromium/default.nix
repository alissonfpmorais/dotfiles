{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.general.browser.chromium;
in
{
  options.modules.general.browser.chromium = {
    enable = mkEnableOption "Enable chromium browser";
  };

  config = mkIf cfg.enable {
    users.users.alissonfpmorais.packages = with pkgs; [
      chromium
    ];
  };
}