{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.general.croc;
in
{
  options.modules.general.croc = {
    enable = mkEnableOption "Enable Croc cli";
  };

  config = mkIf cfg.enable {
    users.users.alissonfpmorais.packages = with pkgs; [
      croc
    ];
  };
}
