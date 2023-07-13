{ lib, pkgs, ... }:
{
  home.stateVersion = "22.11";
  dconf.settings = {
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
      ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding="<Super>t";
      command="kgx";
      name="Open Terminal";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      binding="<Super>e";
      command="emacsclient -c -a 'emacs'";
      name="Open emacs client";
    };
  };
  # Swap fcitx-engines to fcitx5 (error while upgrading from 22.11 to 23.05)
  # nixpkgs.overlays = [
  #   (self: super: {
  #     fcitx-engines = pkgs.fcitx5;
  #   })
  # ];
  programs = {
    # emacs = {
    #   enable = true;
    # };
    git = {
      enable = true;
      aliases = {
        apply-gitignore = "!git ls-files -ci --exclude-standard -z | xargs -0 git rm --cached";
        lg1 = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all";
        lg2 = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(auto)%d%C(reset)%n'' %C(white)%s%C(reset) %C(dim white)- %an%C(reset)'";
        lg = "lg1";
      };
      extraConfig = {
        core = {
          autocrlf = "input";
        };
        init.defaultBranch = "main";
        safe.directory = "/etc/nixos";
      };
      userEmail = "alissonfpmorais@gmail.com";
      userName = "Alisson Morais";
    };
    zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      enableSyntaxHighlighting = true;
      initExtra = ''
        ## include config generated via "p10k configure" manually; zplug cannot edit home manager's zshrc file.
        ## note that I moved it from its original location to /etc/nixos/p10k
        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

        ## Initializations
        eval "$(direnv hook zsh)"

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
      shellAliases = lib.recursiveUpdate (import ./job/shell-aliases.priv.nix) {
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
  # services = {
  #   emacs = {
  #     client.arguments = [
  #       "-c"
  #       "-a 'emacs'"
  #     ];
  #     client.enable = true;
  #     enable = true;
  #     socketActivation.enable = true;
  #   };
  # };
}