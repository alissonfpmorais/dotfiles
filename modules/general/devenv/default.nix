{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.general.devenv;
in
{
  options.modules.general.devenv = {
    enable = mkEnableOption "Enable devenv cli";
  };

  config = mkIf cfg.enable {
    users.users.alissonfpmorais.packages = with pkgs; [
      devenv
    ];
  };
}
