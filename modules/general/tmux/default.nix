{ config, lib, ... }:

with lib;

let
  cfg = config.modules.general.tmux;
in
{
  options.modules.general.tmux = {
    enable = mkEnableOption "Enable Tmux terminal emulator";
  };

  config = mkIf cfg.enable {
    home-manager.users.alissonfpmorais = {
      programs.tmux = {
        enable = true;
        clock24 = true;
        extraConfig = ''
          bind-key h select-pane -L
          bind-key j select-pane -D
          bind-key k select-pane -U
          bind-key l select-pane -R

          set-option -g status-position top
        '';
        historyLimit = 10000;
        keyMode = "vi";
        mouse = true;
        prefix = "C-s";
        shell = "${pkgs.zsh}/bin/zsh";
        plugins = with pkgs; [
          tmuxPlugins.battery
          tmuxPlugins.open
          tmuxPlugins.pain-control
          tmuxPlugins.gruvbox
          {
            plugin = tmuxPlugins.resurrect;
            extraConfig = "set -g @resurrect-strategy-nvim 'session'";
          }
          {
            plugin = tmuxPlugins.continuum;
            extraConfig = ''
              set -g @continuum-restore 'on'
              set -g @continuum-save-interval '60' # minutes
            '';
          }
        ];
      };
    };
  };
}