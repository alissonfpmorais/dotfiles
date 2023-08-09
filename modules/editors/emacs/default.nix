{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.editors.emacs;
in
{
  options.modules.editors.emacs = {
    enable = mkEnableOption "Enable emacs editor";
    defaultEditor = mkOption {
      type = types.bool;
      default = false;
      description = "Use emacs as default editor";
    };
    doom = {
      enable = mkEnableOption "Enable doom emacs framework";
      repoUrl = mkOption {
        type = types.str;
        default = "https://github.com/doomemacs/doomemacs";
      };
    };
  };

  config = mkIf cfg.enable {
    services.emacs = {
      enable = true;
      package = with pkgs; ((emacsPackagesFor emacs).emacsWithPackages (epkgs: [ epkgs.vterm ]));
    };

    users.users.alissonfpmorais.packages = with pkgs; [
      ## Emacs itself
      # native-comp needs 'as', provided by this
      binutils       
      # 28.2 + native-comp
      # ((emacsPackagesFor emacs-unstable).emacsWithPackages
      #   (epkgs: [ epkgs.vterm ]))

      ## Doom dependencies
      (ripgrep.override {withPCRE2 = true;})
      gnutls              # for TLS connectivity

      ## Optional dependencies
      # faster projectile indexing
      fd
      # for image-dired
      imagemagick
      # in-emacs gnupg prompts
      # (mkIf (config.programs.gnupg.agent.enable)
      #   pinentry_emacs)
      # for undo-fu-session/undo-tree compression
      zstd

      ## Module dependencies
      # :checkers spell
      (aspellWithDicts (ds: with ds; [ en en-computers en-science ]))
      # :tools editorconfig
      editorconfig-core-c # per-project style config
      # :tools markdown
      pandoc
      # :tools lookup & :lang org +roam
      sqlite
      # :lang latex & :lang org (latex previews)
      # texlive.combined.scheme-medium
      # :lang beancount
      # beancount
      # unstable.fava  # HACK Momentarily broken on nixos-unstable
    ];

    environment.sessionVariables = {
      PATH = [
        "$XDG_CONFIG_HOME/emacs/bin"
      ];
    };

    # modules.shell.zsh.rcFiles = [ "${configDir}/emacs/aliases.zsh" ];

    # fonts.fonts = [ pkgs.emacs-all-the-icons-fonts ];

    system.userActivationScripts = mkIf cfg.doom.enable {
      installDoomEmacs = ''
        if [ ! -d "$XDG_CONFIG_HOME/emacs" ]; then
           ${pkgs.git}/bin/git clone --depth=1 --single-branch "${cfg.doom.repoUrl}" "$XDG_CONFIG_HOME/emacs"
        fi
      '';
    };
  };
}
