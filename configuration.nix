# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # nix.package = pkgs.nixUnstable;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # nix.gc = {
  #   automatic = true;
  #   dates = "weekly";
  #   options = "--delete-older-than 30d";
  # };
  
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
    # allowInsecurePredicate = pkg: true;

    # Statically allow insecure packages
    # permittedInsecurePackages = [
    #   "nodejs-16.20.0"
    # ];
  };

  environment.shells = with pkgs; [ zsh ];
  environment.pathsToLink = [ "/share/zsh" ];
  environment.variables = lib.recursiveUpdate (import ./private/job/envs.nix) {};

  # environment = {
  #   pathsToLink = [ "/share/zsh" ];
  #   sessionVariables = {
  #     # These are the defaults, and xdg.enable does set them, but due to load
  #     # order, they're not set before environment.variables are set, which could
  #     # cause race conditions.
  #     XDG_CACHE_HOME  = "$HOME/.cache";
  #     XDG_CONFIG_HOME = "$HOME/.config";
  #     XDG_DATA_HOME   = "$HOME/.local/share";
  #     XDG_BIN_HOME    = "$HOME/.local/bin";
  #   };
  #   shells = with pkgs; [ zsh ];
  #   variables = lib.recursiveUpdate (import ./private/job/envs.nix) {};
  # }

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
    pkgs.networkmanager-openvpn
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
    # emacs
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
    neovim
    nixos-option
    nodejs_20
    pciutils
    python311
    python311Packages.pip
    ripgrep
    robo3t
    rustc
    tldr
    tree
    unzip
    vim
    vscode
    wget
  ];

  # environment.shellInit = ''
  #   export PATH="$PATH:$HOME/.config/emacs/bin"
  # '';

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
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
    ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

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
  # services.emacs.enable = true;

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
