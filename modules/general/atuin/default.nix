{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.general.atuin;
in
{
  options.modules.general.atuin = {
    enable = mkEnableOption "Enable atuin cli";
  };

  config = mkIf cfg.enable {
    users.users.alissonfpmorais.packages = with pkgs; [
      atuin
    ];
  };
}
