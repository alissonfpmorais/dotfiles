{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.shells.zsh;
in
{
  options.modules.shells.zsh = {
    enable = mkEnableOption "Zsh shell";
    extraAliases = mkOption {
      type = types.attrs;
      default = {};
      description = "Extra aliases to add";
      example = {
        MY_ENV_VAR = "value";
      };
    };
    initExtra = mkOption {
      default = "";
      type = types.lines;
      description = "Extra commands that should be added to <filename>.zshrc</filename>.";
    };
    initExtraFirst = mkOption {
      default = "";
      type = types.lines;
      description = "Commands that should be added to top of <filename>.zshrc</filename>.";
    };
  };

  config = mkIf cfg.enable {
    environment.pathsToLink = [ "/share/zsh" ];

    environment.shells = [ pkgs.zsh ];

    home-manager.users.alissonfpmorais = {
      programs.zsh = {
        enable = true;
        enableAutosuggestions = true;
        enableCompletion = true;
        enableSyntaxHighlighting = true;
        initExtra = ''
          ${cfg.initExtra}
          ## include config generated via "p10k configure" manually; zplug cannot edit home manager's zshrc file.
          ## note that I moved it from its original location to /etc/nixos/p10k
          [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

          ## Keybindings section
          bindkey -e
          bindkey '^[[7~' beginning-of-line                               # Home key
          bindkey '^[[H' beginning-of-line                                # Home key
          if [[ "''${terminfo[khome]}" != "" ]]; then
            bindkey "''${terminfo[khome]}" beginning-of-line              # [Home] - Go to beginning of line
          fi
          bindkey '^[[8~' end-of-line                                     # End key
          bindkey '^[[F' end-of-line                                      # End key
          if [[ "''${terminfo[kend]}" != "" ]]; then
            bindkey "''${terminfo[kend]}" end-of-line                     # [End] - Go to end of line
          fi
          bindkey '^[[2~' overwrite-mode                                  # Insert key
          bindkey '^[[3~' delete-char                                     # Delete key
          bindkey '^[[C'  forward-char                                    # Right key
          bindkey '^[[D'  backward-char                                   # Left key
          bindkey '^[[5~' history-beginning-search-backward               # Page up key
          bindkey '^[[6~' history-beginning-search-forward                # Page down key
          # Navigate words with ctrl+arrow keys
          bindkey '^[Oc' forward-word                                     #
          bindkey '^[Od' backward-word                                    #
          bindkey '^[[1;5D' backward-word                                 #
          bindkey '^[[1;5C' forward-word                                  #
          bindkey '^H' backward-kill-word                                 # delete previous word with ctrl+backspace
          bindkey '^[[Z' undo                                             # Shift+tab undo last action
          
          ## Theming section
          autoload -U colors
          colors
        '';
        initExtraFirst = ''
          ${cfg.initExtraFirst}
        '';
        plugins = [
          {
            name = "zsh-nix-shell";
            file = "nix-shell.plugin.zsh";
            src = pkgs.fetchFromGitHub {
              owner = "chisui";
              repo = "zsh-nix-shell";
              rev = "v0.7.0";
              sha256 = "oQpYKBt0gmOSBgay2HgbXiDoZo5FoUKwyHSlUrOAP5E=";
            };
          }
        ];
        shellAliases = recursiveUpdate cfg.extraAliases {
          dr = "doppler run";
          # lbup = "UID=$(id -u) GID=$(id -g) docker-compose -f ~/projects/alissonfpmorais/livebook/docker-compose.yml up -d --build";
          # lbdown = "UID=$(id -u) GID=$(id -g) docker-compose -f ~/projects/alissonfpmorais/livebook/docker-compose.yml down --rmi all";
          # lblogs = "UID=$(id -u) GID=$(id -g) docker-compose -f ~/projects/alissonfpmorais/livebook/docker-compose.yml logs --tail=\"all\"";
          # lblink = "lblogs | grep running";
          # lbl = "docker run -p 8080:8080 -p 8081:8081 --pull always -u $(id -u):$(id -g) -v /home/alissonfpmorais/projects/alissonfpmorais/livebook:/data ghcr.io/livebook-dev/livebook";
          gitia = "git add --intent-to-add";
          gitui = "git update-index --assume-unchanged";
          nicfg = "sudo nano /etc/nixos/configuration.nix";
          nigbg = "sudo nix-collect-garbage --delete-older-than";
          niopt = "nixos-option";
          nicup = "sudo nix-channel --update";
          nifku = "sudo nix flake update";
          niupdt = "sudo nixos-rebuild switch";
        };
        zplug = {
          enable = true;
          plugins = [
            { name = "plugins/aws";               tags = [from:oh-my-zsh]; }
            { name = "plugins/colored-man-pages"; tags = [from:oh-my-zsh]; }
            { name = "plugins/colorize";          tags = [from:oh-my-zsh]; }
            { name = "plugins/command-not-found"; tags = [from:oh-my-zsh]; }
            { name = "plugins/cp";                tags = [from:oh-my-zsh]; }
            { name = "plugins/docker";            tags = [from:oh-my-zsh]; }
            { name = "plugins/fzf";               tags = [from:oh-my-zsh]; }
            { name = "plugins/git";               tags = [from:oh-my-zsh]; }
            { name = "plugins/gitignore";         tags = [from:oh-my-zsh]; }
            # { name = "plugins/tmux";              tags = [from:oh-my-zsh]; }
            { name = "plugins/ripgrep";           tags = [from:oh-my-zsh]; }
            # { name = "plugins/themes";            tags = [from:oh-my-zsh]; }
            # { name = "kutsan/zsh-system-clipboard"; }  # IMPORTANT
            { name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; }
          ];
        };
      };
    };

    programs.zsh.enable = true;

    users.defaultUserShell = pkgs.zsh;

    users.users.alissonfpmorais.packages = with pkgs; [
      bat
      cargo
      clang
      coreutils
      eza
      fd
      fzf
      inotify-tools
      jq
      neofetch
      nixos-option
      pciutils
      ripgrep
      rustc
      steam-run
      tldr
      tree
      unzip
      wget
    ];
  };
}