{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.general.git;
in
{
  options.modules.general.git = {
    enable = mkEnableOption "Git version control";
    defaultBranch = mkOption {
      type = types.str;
      default = "main";
      example = "main";
      description = "Default branch while creating a new git's repository";
    };
    extraAliases = mkOption {
      type = types.attrs;
      default = { };
      description = "Extra aliases to add";
      example = {
        MY_ENV_VAR = "value";
      };
    };
    userEmail = mkOption {
      type = types.str;
      default = "alissonfpmorais@gmail.com";
      example = "gandalf@lotr.com";
      description = "Git user's email";
    };
    userName = mkOption {
      type = types.str;
      default = "Alisson Morais";
      example = "Gandalf, The Gray";
      description = "Git user's name";
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.alissonfpmorais = {
      programs = {
        git = {
          enable = true;
          aliases = recursiveUpdate cfg.extraAliases {
            apply-gitignore = "!git ls-files -ci --exclude-standard -z | xargs -0 git rm --cached";
            lg1 = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all";
            lg2 = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(auto)%d%C(reset)%n'' %C(white)%s%C(reset) %C(dim white)- %an%C(reset)'";
            lg = "lg1";
          };
          diff-so-fancy.enable = true;
          extraConfig = {
            core = {
              autocrlf = "input";
              editor = "code --wait";
            };
            init.defaultBranch = cfg.defaultBranch;
            safe.directory = "/etc/nixos";
          };
          userEmail = cfg.userEmail;
          userName = cfg.userName;
        };
        lazygit = {
          enable = true;
          settings = {
            os.edit = "floaterm";
            # keybinding.universal.return = "<c-bs>";
          };
        };
      };
    };

    users.users.alissonfpmorais.packages = with pkgs; [
      git-lfs
      gitFull
    ];
  };
}
