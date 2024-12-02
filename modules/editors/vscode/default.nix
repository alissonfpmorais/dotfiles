{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.editors.vscode;
in
{
  options.modules.editors.vscode = {
    enable = mkEnableOption "Enable vscode editor";
    defaultEditor = mkOption {
      type = types.bool;
      default = false;
      description = "Use vscode as default editor";
    };
  };

  config = mkIf cfg.enable {
    users.users.alissonfpmorais.packages = with pkgs; [
      vscode
    ];
  };
}
