{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.editors.zed;
in
{
  options.modules.editors.zed = {
    enable = mkEnableOption "Enable zed editor";
    defaultEditor = mkOption {
      type = types.bool;
      default = false;
      description = "Use zed as default editor";
    };
  };

  config = mkIf cfg.enable {
    users.users.alissonfpmorais.packages = with pkgs; [
      zed-editor
    ];
  };
}
