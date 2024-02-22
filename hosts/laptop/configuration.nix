# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, hyprland, lib, pkgs, ... }:
{
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

  networking.hostName = "afpmLaptop"; # Define your hostname.
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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable GDM server
  # services.xserver.displayManager.gdm.enable = true;

  # Enable SDDM server
  services.xserver.displayManager.sddm.enable = true;
  # services.xserver.displayManager.setupCommands=''
  #   #!/bin/sh
  #   # Xsetup - run as root before the login dialog appears
  #   xrandr --output eDP-1 --mode 1920x1080
  #   xrandr --output HDMI-A-3 --off
  # '';

  # Enable gnome-keyring after login
  security.pam.services.sddm.enableGnomeKeyring = true;
  security.pam.services.login.enableGnomeKeyring = true;

  # Enable the Hyprland Compositor
  programs.hyprland = {
    enable = true;
    package = hyprland.packages."${pkgs.system}".hyprland;
  };

  # Enable the GNOME Desktop Environment.
  # services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "altgr-intl";
  };

  # Configure console keymap
  console.keyMap = "us";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.alissonfpmorais = {
    isNormalUser = true;
    description = "Alisson Morais";
    extraGroups = [
      "docker"
      "networkmanager"
      "wheel"
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.variables = lib.recursiveUpdate (import ./job/envs.priv.nix) {};

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
    dbeaver
    docker
    docker-compose
    doppler
    gnumake
    nodejs_20
    python311
    python311Packages.pip

    # May be removed
    robo3t

    # Hyprland's default terminal
    kitty

    # Hyprland's wallpaper
    hyprlang
    hyprpaper

    # Gnome-keyring
    gnome.gnome-keyring
    libsecret
  ];

  # environment.shellInit = ''
  #   export PATH="$PATH:$HOME/.config/emacs/bin"
  # '';

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Enable emacs daemon
  # services.emacs.enable = true;

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

  modules = {
    editors = {
      enable = true;
      defaultEditor = "neovim";
      # androidStudio.enable = true;
      # emacs = {
      #   enable = true;
      #   doom.enable = true;
      # };
      # idea.enable = true;
      neovim = {
        enable = true;
        astro.enable = true;
      };
      # rider.enable = true;
      vscode.enable = true;
    };
    fonts = {
      enable = true;
      defaults = [ "FiraCode" ];
      installs = [ "FiraCode" ];
    };
    games = {
      steam.enable = false;
    };
    general = {
      aws.enable = true;
      browser = {
        brave.enable = true;
        chromium.enable = true;
        edge.enable = true;
        firefox.enable = true;
        vivaldi.enable = true;
      };
      git.enable = true;
      lorri.enable = true;
      ngrok.enable = true;
      # pulumi.enable = false;
      # postman.enable = true;
      zoxide.enable = true;
    };
    shells = {
      zsh = {
        enable = true;
        extraAliases = (import ./job/shell-aliases.priv.nix);
      };
    };
  };
}
