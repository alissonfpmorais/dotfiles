{ config, lib, pkgs, ... }:

with lib;

let
  editors = config.modules.editors;
  nvim = editors.neovim;
in
{
  options.modules.editors.neovim = {
    enable = mkEnableOption "Enable neovim editor";
    astro = {
      enable = mkEnableOption "Enable Astro NVim";
      repoUrl = mkOption {
        type = types.str;
        default = "https://github.com/AstroNvim/AstroNvim";
      };
    };
    defaultEditor = mkOption {
      type = types.bool;
      default = false;
      description = "Use neovim as default editor";
    };
  };

  config = mkIf (editors.enable && nvim.enable) {
    programs.neovim = {
      defaultEditor = nvim.defaultEditor;
      enable = true;
      viAlias = true;
      vimAlias = true;
    };

    users.users.alissonfpmorais = with pkgs; mkMerge [
      # Basic NVim dependencies
      { 
        packages = [
          neovim
          ripgrep
          vim
        ];
      }

      # Astro NVim dependencies
      (mkIf nvim.astro.enable {
        packages = [
          bottom
          gdu
          lazygit
          nodejs_20
          python312
          tree-sitter
        ];
      })
    ];

    environment.sessionVariables = {
      PATH = [
        "$XDG_CONFIG_HOME/nvim"
      ];
    };

    system.userActivationScripts = mkIf nvim.astro.enable {
      installAstroNVim = ''
        if [ ! -d "$XDG_CONFIG_HOME/nvim" ]; then
          ${pkgs.git}/bin/git clone --depth 1 "${nvim.astro.repoUrl}" "$XDG_CONFIG_HOME/nvim"
        fi
      '';
    };
  };
} 