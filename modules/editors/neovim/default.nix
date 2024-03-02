{ config, lib, pkgs, nixvim, ... }:

with lib;

let
  editors = config.modules.editors;
  nvim = editors.neovim;
in
{
  options.modules.editors.neovim = {
    enable = mkEnableOption "Enable neovim editor";
    nixvim = {
      enable = mkEnableOption "Enable Nixvim";
    };
    defaultEditor = mkOption {
      type = types.bool;
      default = false;
      description = "Use neovim as default editor";
    };
  };

  config = mkIf (editors.enable && nvim.enable) {
    home-manager.users.alissonfpmorais = {
      imports = [
        nixvim.homeManagerModules.nixvim
      ];

      programs.neovim = mkIf (!nvim.nixvim.enable) {
        defaultEditor = nvim.defaultEditor;
        enable = true;
        viAlias = true;
        vimAlias = true;
      };

      programs.nixvim = mkIf nvim.nixvim.enable {
        enable = true;

        colorschemes.gruvbox.enable = true;

        globals.mapleader = " ";

        keymaps = [ ];

        options = {
          number = true;
          relativenumber = true;
          shiftwidth = 2;
          timeoutlen = 300;
        };

        plugins = {
          direnv.enable = true;
          floaterm.enable = true;
          gitblame.enable = true;
          gitgutter.enable = true;
          gitsigns.enable = true;
          indent-blankline.enable = true;
          lsp = {
            enable = true;
            servers =
              {
                bashls.enable = true;
                cssls.enable = true;
                elmls.enable = true;
                elixirls.enable = true;
                graphql.enable = true;
                jsonls.enable = true;
                lua-ls.enable = true;
                nixd.enable = true;
                tailwindcss.enable = true;
                tsserver.enable = true;
                yamlls.enable = true;
              };
          };
          lsp-format.enable = true;
          nvim-cmp = {
            enable = true;
            autoEnableSources = true;
            sources = [
              { name = "nvim_lsp"; }
              { name = "path"; }
              { name = "buffer"; }
            ];
          };
          nvim-lightbulb.enable = true;
          oil.enable = true;
          project-nvim.enable = true;
          rainbow-delimiters.enable = true;
          lualine.enable = true;
          telescope.enable = true;
          treesitter.enable = true;
          which-key = {
            enable = true;
            registrations =
              {
                "<leader>" = {
                  " " = [
                    "<cmd>Telescope buffers<CR>"
                    "Telescope find buffers"
                  ];
                  f = {
                    name = "Telescope find";
                    f = [
                      "<cmd>Telescope find_files<CR>"
                      "files"
                    ];
                    g = [
                      "<cmd>Telescope git_files<CR>"
                      "git"
                    ];
                    s = [
                      "<cmd>Telescope live_grep<CR>"
                      "text"
                    ];
                  };
                  t = {
                    name = "Floaterm";
                    g = [
                      "<cmd>FloatermNew lazygit<CR>"
                      "lazygit"
                    ];
                    t = [
                      "<cmd>FloatermNew terminal<CR>"
                      "terminal"
                    ];
                  };
                };
              };
          };
        };
      };
    };

    users.users.alissonfpmorais = with pkgs; mkMerge
      [
        # Basic NVim dependencies
        {
          packages = [
            ripgrep
            vim
          ];
        }

        (mkIf nvim.nixvim.enable {
          packages = [ ];
        })
      ];

    environment.sessionVariables = {
      PATH = [
        "$XDG_CONFIG_HOME/nvim"
      ];
    };
  };
}

