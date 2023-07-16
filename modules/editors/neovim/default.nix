{ config, lib, pkgs, ... }:

with lib;

let
  editors = config.modules.editors;
  nvim = editors.neovim;
in
{
  options.modules.editors.neovim = {
    enable = mkEnableOption "Enable neovim editor";
    defaultEditor = mkOption {
      type = types.bool;
      default = false;
      description = "Use neovim as default editor";
    };
  };

  # TODO: setup NvChad
  config = mkIf (editors.enable && nvim.enable) {
    programs.neovim = {
      defaultEditor = nvim.defaultEditor;
      enable = true;
      viAlias = true;
      vimAlias = true;
    };

    users.users.alissonfpmorais.packages = with pkgs; [
      neovim
      ripgrep
      vim
    ];
  };
}