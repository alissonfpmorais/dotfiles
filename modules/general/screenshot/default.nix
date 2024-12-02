{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.general.screenshot;
in
{
  options.modules.general.screenshot = {
    enable = mkEnableOption "Enable screenshot apps";
  };

  config = mkIf cfg.enable {
    users.users.alissonfpmorais.packages = with pkgs; [
      grim
      slurp
      swappy
      wl-clipboard
    ];

    home-manager.users.alissonfpmorais = {
      home.file.".config/swappy/config".text = ''
        [Default]
        save_dir=$HOME/Pictures
        save_filename_format=swappy-%Y%m%d-%H%M%S.png
        show_panel=false
        line_size=5
        text_size=20
        text_font=sans-serif
        paint_mode=brush
        early_exit=true
        fill_shape=false
      '';
    };
  };
}
