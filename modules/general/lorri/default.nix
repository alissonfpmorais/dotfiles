{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.general.lorri;
  zsh = config.modules.shells.zsh;
in
{
  options.modules.general.lorri = {
    enable = mkEnableOption "Lorri's integration for development";
  };

  config = mkIf cfg.enable {
    modules.shells = {
      zsh = mkIf zsh.enable {
        initExtra = ''
          ## Initializations
          eval "$(direnv hook zsh)"
        '';
      };
    };

    services.lorri.enable = true;

    users.users.alissonfpmorais.packages = with pkgs; [
      direnv
    ];
  };
}