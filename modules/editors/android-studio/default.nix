{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.editors.androidStudio;
in
{
  options.modules.editors.androidStudio = {
    enable = mkEnableOption "Enable Android Studio editor";
  };

  config = mkIf cfg.enable {
    users.users.alissonfpmorais.packages = with pkgs; [
      android-studio
      android-tools
    ];
  };
}