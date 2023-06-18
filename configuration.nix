# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

let
  homeManager =
    fetchTarball
      https://github.com/nix-community/home-manager/archive/release-23.05.tar.gz;
  rev53951cTarball =
    fetchTarball
      https://github.com/NixOS/nixpkgs/archive/53951c0c1444e500585205e8b2510270b2ad188f.tar.gz;
  rev7cf5ccTarball =
    fetchTarball
      https://github.com/NixOS/nixpkgs/archive/7cf5ccf1cdb2ba5f08f0ac29fc3d04b0b59a07e4.tar.gz;
  unstableTarball =
    fetchTarball
      https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz;
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      "${homeManager}/nixos"
    ];


  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  # Swap fcitx-engines to fcitx5 (error while upgrading from 22.11 to 23.05)
  # nixpkgs.overlays = [
  #   (self: super: {
  #     fcitx-engines = pkgs.fcitx5;
  #   })
  # ];

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "br";
    xkbVariant = "";
  };

  # Configure console keymap
  console.keyMap = "br-abnt2";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Enable NVidia drivers
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.enable = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  hardware.nvidia.modesetting.enable = true;

  users.defaultUserShell = pkgs.zsh;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.alissonfpmorais = {
    isNormalUser = true;
    description = "Alisson Morais";
    extraGroups = [
      "docker"
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [
      firefox
    #  thunderbird
    ];
  };

  # Nixpkgs config
  nixpkgs.config = {
    # Allow unfree packages
    allowUnfree = true;
    
    # Dinamically (dis)allow insecure packages
    #allowInsecurePredicate = pkg: true;

    # Enable unstable packages to be installed
    packageOverrides = pkgs: {
      rev53951c = import rev53951cTarball {
        config = config.nixpkgs.config;
      };
      rev7cf5cc = import rev7cf5ccTarball {
        config = config.nixpkgs.config;
      };
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
    };

    # Statically allow insecure packages
    #permittedInsecurePackages = [
    #  "nodejs-16.20.0"
    #];
  };

  environment.shells = with pkgs; [ zsh ];
  environment.pathsToLink = [ "/share/zsh" ];
  environment.variables = lib.recursiveUpdate (import ./private/job/envs.nix) {};

  # Enable docker
  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  networking.extraHosts = ''
    127.0.0.1 mongo1
    127.0.0.1 mongo2
    127.0.0.1 mongo3
  '';

  networking.networkmanager.plugins = [
    # Specific revisions
    pkgs.rev7cf5cc.networkmanager-openvpn
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # default channel
    brave
    cargo
    chromium
    clang
    coreutils
    dbeaver
    direnv
    docker
    docker-compose
    doppler
    (import ./programs/emacs.nix { inherit pkgs; })
    fd
    firefox
    fzf
    gitFull
    gnomeExtensions.pop-shell
    gnumake
    inotify-tools
    lazygit
    microsoft-edge
    neofetch
    nixos-option
    nodejs_20
    pciutils
    python311
    python311Packages.pip
    ripgrep
    robo3t
    rustc
    tldr
    unzip
    vim
    vscode
    wget

    # Specific revisions
    rev53951c.openvpn

    # Unstable channel
    unstable.neovim
  ];

  fonts = {
    enableDefaultFonts = true;
    fontconfig = {
      defaultFonts = {
        monospace = [ "FiraCode" ];
        sansSerif = [ "FiraCode" ];
        serif = [ "FiraCode" ];
      };
    };
    fonts = with pkgs; [
      (unstable.nerdfonts.override { fonts = [ "FiraCode" ]; })
    ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  home-manager.users.alissonfpmorais = {
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
    nixpkgs.overlays = [
      (self: super: {
        fcitx-engines = pkgs.fcitx5;
      })
    ];
    programs.git = {
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
    programs.zsh = {
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
      shellAliases = lib.recursiveUpdate (import ./private/job/shell-aliases.nix) {
        dr = "doppler run";
        # lbup = "UID=$(id -u) GID=$(id -g) docker-compose -f ~/projects/alissonfpmorais/livebook/docker-compose.yml up -d --build";
        # lbdown = "UID=$(id -u) GID=$(id -g) docker-compose -f ~/projects/alissonfpmorais/livebook/docker-compose.yml down --rmi all";
        # lblogs = "UID=$(id -u) GID=$(id -g) docker-compose -f ~/projects/alissonfpmorais/livebook/docker-compose.yml logs --tail=\"all\"";
        # lblink = "lblogs | grep running";
        # lbl = "docker run -p 8080:8080 -p 8081:8081 --pull always -u $(id -u):$(id -g) -v /home/alissonfpmorais/projects/alissonfpmorais/livebook:/data ghcr.io/livebook-dev/livebook";
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

  programs.neovim = {
    defaultEditor = true;
    enable = true;
    viAlias = true;
    vimAlias = true;
  };

  programs.zsh.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Enable emacs daemon
  services.emacs.enable = true;

  # Enable lorri integration between nix-shell and direnv
  services.lorri.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}
