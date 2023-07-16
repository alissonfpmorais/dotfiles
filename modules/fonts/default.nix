{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.fonts;
in
{
  options.modules.fonts = {
    enable = mkEnableOption "Enable shell fonts";
    defaults = mkOption {
      type = with types; listOf str;
      default = [];
      description = "Default order for all font types";
    };
    defaultMonospace = mkOption {
      type = with types; listOf str;
      default = [];
      description = "Default order for monospace fonts";
    };
    defaultSansSerif = mkOption {
      type = with types; listOf str;
      default = [];
      description = "Default order for sans serif fonts";
    };
    defaultSerif = mkOption {
      type = with types; listOf str;
      default = [];
      description = "Default order for serif fonts";
    };
    enableDefaultFonts = mkOption {
      type = types.bool;
      default = true;
    };
    installs = mkOption {
      type = with types; listOf str;
      default = [];
      description = "Fonts to install";
    };
  };

  config = mkIf cfg.enable {
    fonts = {
      enableDefaultFonts = cfg.enableDefaultFonts;
    
      fontconfig = {
        defaultFonts = {
          monospace = if cfg.defaultMonospace != [] then cfg.defaultMonospace else cfg.defaults;
          sansSerif = if cfg.defaultSansSerif != [] then cfg.defaultSansSerif else cfg.defaults;
          serif = if cfg.defaultSerif != [] then cfg.defaultSerif else cfg.defaults;
        };
      };

      fonts = with pkgs; [
        (nerdfonts.override { fonts = cfg.installs; })
      ];
    };
  };
}