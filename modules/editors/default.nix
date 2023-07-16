{ config, lib, ... }:

with lib;

let
  cfg = config.modules.editors;
in
{
  imports = [
    ./emacs
    ./neovim
    ./vscode
  ];

  options.modules.editors = {
    enable = mkEnableOption "Enable editors activation";
    defaultEditor = mkOption {
      type = with types; enum [ "emacs" "neovim" "vscode" ];
      default = "";
      description = "Shell's default editor";
    };
  };

  config = mkIf cfg.enable {
    modules.editors.emacs = {
      defaultEditor = cfg.defaultEditor == "emacs";
    };
    modules.editors.neovim = {
      defaultEditor = cfg.defaultEditor == "neovim";
    };
    modules.editors.vscode = {
      defaultEditor = cfg.defaultEditor == "vscode";
    };
  };
}