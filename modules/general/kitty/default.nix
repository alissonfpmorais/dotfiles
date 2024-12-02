{ config, lib, ... }:

with lib;

let
  cfg = config.modules.general.kitty;
in
{
  options.modules.general.kitty = {
    enable = mkEnableOption "Enable Kitty terminal emulator";
  };

  config = mkIf cfg.enable {
    home-manager.users.alissonfpmorais = {
      programs.kitty = {
        enable = true;
        theme = "Gruvbox Dark";
        settings = {
          hide_window_decorations = if config.modules.de.name == "hyprland" then "yes" else "no";
        };
      };
    };
  };
}