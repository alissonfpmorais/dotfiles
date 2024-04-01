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

        clipboard = {
          register = "unnamedplus";
          providers = {
            wl-copy.enable = true;
          };
        };

        colorschemes.gruvbox.enable = true;

				# autoCmd = [
				# 	{
				# 		event = [ "BufWritePre" ];
				# 		pattern = [
				# 			"*.tsx"
				# 			"*.ts"
				# 			"*.jsx"
				# 			"*.js"
				# 		];
				# 		command = "npm run lint";
				# 	}
				# ];

        extraPlugins = with pkgs.vimPlugins; [
          lualine-lsp-progress
          vim-dadbod
          vim-dadbod-completion
          vim-dadbod-ui
          {
            plugin = vim-dadbod-ui;
            config = ''
              						let g:db_ui_execute_on_save = 0
              						'';
          }
          vim-visual-multi
        ];

        globals.mapleader = " ";

        keymaps = [ ];

        options = {
          number = true;
          relativenumber = true;
          shiftwidth = 2;
          tabstop = 2;
          timeoutlen = 300;
        };

        plugins = {
          cmp = {
            enable = true;
            autoEnableSources = true;
            settings = {
              mapping = {
                "<C-Space>" = "cmp.mapping.complete()";
                "<C-d>" = "cmp.mapping.scroll_docs(-4)";
                "<C-e>" = "cmp.mapping.close()";
                "<C-f>" = "cmp.mapping.scroll_docs(4)";
                "<CR>" = "cmp.mapping.confirm({ select = true })";
                "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
                "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
              };
              performance = {
                fetching_timeout = 300;
              };
              snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";
              sources = [
                { name = "nvim_lsp"; }
                { name = "nvim_lsp_document_symbol"; }
                { name = "nvim_lsp_signature_help"; }
                { name = "nvim_lua"; }
                { name = "path"; }
                # { name = "buffer"; }
              ];
            };
          };
          cmp-buffer.enable = true;
          cmp-cmdline.enable = true;
          cmp-nvim-lsp.enable = true;
          cmp-nvim-lsp-document-symbol.enable = true;
          cmp-nvim-lsp-signature-help.enable = true;
          cmp-nvim-lua.enable = true;
          cmp-path.enable = true;
          comment-nvim.enable = true;
          debugprint.enable = true;
          direnv.enable = true;
          floaterm = {
            enable = true;
            height = 0.9;
            width = 0.9;
          };
          gitblame.enable = true;
          gitsigns.enable = true;
          illuminate.enable = true;
          indent-blankline.enable = true;
          intellitab.enable = true;
          lsp = {
            enable = true;
            keymaps = {
              diagnostic = {
                "<leader>gj" = "goto_next";
                "<leader>gk" = "goto_prev";
              };
              lspBuf = {
                "<leader>gK" = "hover";
                "<leader>gD" = "references";
                "<leader>gd" = "definition";
                "<leader>gi" = "implementation";
                "<leader>gt" = "type_definition";
								"<leader>rn" = "rename";
								"<leader>ca" = "code_action";
              };
              silent = true;
            };
            servers =
              {
                bashls.enable = true;
                cmake.enable = true;
                cssls.enable = true;
                dockerls.enable = true;
                elmls.enable = true;
                elixirls.enable = true;
								# eslint.enable = true;
                gleam.enable = true;
								gopls.enable = true;
                graphql.enable = true;
                html.enable = true;
                jsonls.enable = true;
                lua-ls.enable = true;
                # nixd.enable = true;
                tailwindcss.enable = true;
                tsserver.enable = true;
                yamlls.enable = true;
              };
          };
          lsp-format.enable = true;
          # lspsaga.enable = true;
          luasnip = {
            enable = true;
            extraConfig = {
              enable_autosnippets = true;
              store_selection_keys = "<Tab>";
            };
          };
          mini = {
            enable = true;
            modules = {
              # animate = { };
              notify = { };
            };
          };
          notify = {
            enable = true;
          };
          nvim-lightbulb.enable = true;
          oil = {
						enable = true;
					};
          project-nvim.enable = true;
          rainbow-delimiters.enable = true;
          rest.enable = true;
          lualine = {
            enable = true;
            sections = {
              lualine_c = [
                { icons_enabled = false; name = "filename"; }
                { icons_enabled = true; name = "lsp_progress"; }
              ];
              lualine_x = [
                # { icons_enabled = false; name = "datetime"; }
                { icons_enabled = false; name = "encoding"; }
                { icons_enabled = true; name = "fileformat"; }
                { icons_enabled = true; name = "filetype"; }
              ];
            };
          };
          telescope.enable = true;
          todo-comments.enable = true;
          treesitter.enable = true;
          typescript-tools.enable = true;
          undotree.enable = true;
          which-key = {
            enable = true;
            registrations =
              {
                "<leader>" = {
                  " " = [
                    "<cmd>Telescope buffers<CR>"
                    "Telescope find buffers"
                  ];
                  "<f5>" = [
                    "<cmd>UndotreeToggle<CR>"
                    "Undotree"
                  ];
                  a = {
                    name = "Projects";
                    s = [
                      "<cmd>AddProject<CR>"
                      "add"
                    ];
                  };
                  f = {
                    name = "Telescope find";
                    c = [
                      "<cmd>Telescope commands<CR>"
                      "commands"
                    ];
                    f = [
                      "<cmd>Telescope find_files hidden=true<CR>"
                      "files"
                    ];
                    g = [
                      "<cmd>Telescope git_files hidden=true<CR>"
                      "git"
                    ];
                    p = [
                      "<cmd>Telescope projects<CR>"
                      "projects"
                    ];
                    s = [
                      "<cmd>Telescope live_grep hidden=true<CR>"
                      "text"
                    ];
                  };
                  g = {
                    name = "LSP Actions";

                    # Diagnostics
                    j = "Goto next";
                    k = "Goto previous";

                    # LspBuf
                    D = "Show references";
                    K = "Hover";
                    d = "Goto definition";
                    i = "Goto implementation";
                    t = "Goto type definition";
                  };
                  t = {
                    name = "Floaterm";
                    e = [
                      "<cmd>FloatermNew xplr<CR>"
                      "explorer"
                    ];
                    g = [
                      "<cmd>FloatermNew lazygit<CR>"
                      "lazygit"
                    ];
                    t = [
                      "<cmd>FloatermNew zsh<CR>"
                      "terminal"
                    ];
                  };
                  w = {
                    name = "Database";
                    "<CR>" = [
                      ":normal vip<CR><PLUG>(DBUI_ExecuteQuery)"
                      "run query"
                    ];
                    a = [
                      "<cmd>DBUIAddConnection<CR>"
                      "add connection"
                    ];
                    o = [
                      "<cmd>DBUIToggle<CR>"
                      "open UI"
                    ];
                  };
                };
                "-" = [
                  "<cmd>Oil<CR>"
                  "Open parent directory"
                ];
              };
          };
          wilder = {
            enable = true;
            modes = [ "/" "?" ":" ];
            renderer =
              ''
                                                    wilder.popupmenu_renderer(
                                											wilder.popupmenu_border_theme({
                                												border = 'rounded',
                                												highlights = { border = 'Normal', },
                																				min_height = '30%',
                																				min_width = '20%',
                																				pumblend = 20,
                                											})
                                                    )
              '';
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

