{ lib, pkgs, ... }:
{
  home.stateVersion = "22.11";
  home.file.".config/hypr/hyprpaper.conf".text = ''
    preload = ${/home/alissonfpmorais/Pictures/starry_sky.jpg}
    wallpaper = ,${/home/alissonfpmorais/Pictures/starry_sky.jpg}
    ipc = off
  '';
  services.gnome-keyring = {
    enable = true;
    components = [
      "pkcs11"
      "secrets"
      "ssh"
    ];
  };
  # Ensure that both Hyprland and GTK desktop portals are loaded
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland

      # Added in conjunction with Hyprland's desktop portal to make use file chooser
      pkgs.xdg-desktop-portal-gtk
    ];
  };
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      # This is an example Hyprland config file.
      #
      # Refer to the wiki for more information.

      #
      # Please note not all available settings / options are set here.
      # For a full list, see the wiki
      #

      # See https://wiki.hyprland.org/Configuring/Monitors/
      #hyprctl monitors all
      #monitor=name,resolution,position,scale
      #monitor=DP-1,1920x1080@144,0x0,1
      monitor = [
        "eDP-1,preferred,auto,1"
        "HDMI-A-3,preferred,auto,1,mirror,eDP-1"
      ];

      # See https://wiki.hyprland.org/Configuring/Keywords/ for more

      # Execute your favorite apps at launch
      # exec-once = waybar & hyprpaper & firefox
      exec-once = "hyprpaper";

      # Source a file (multi-file configs)
      # source = ~/.config/hypr/myColors.conf

      # Some default env vars.
      env = [
        "XCURSOR_SIZE,32"

        # Ensure cursor is loaded correctly
        "WLR_NO_HARDWARE_CURSORS,1"

        # Ensure keyring works properly
        "GNOME_KEYRING_CONTROL,/run/user/1000/keyring"
        "SSH_AUTH_SOCK,/run/user/1000/keyring/ssh"
      ];

      # For all categories, see https://wiki.hyprland.org/Configuring/Variables/
      input = {
        kb_layout = "us";
        kb_variant = "altgr-intl";
        # kb_model =
        # kb_options =
        # kb_rules =

        follow_mouse = 1;

        touchpad = {
            natural_scroll = true;
        };

        sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
      };

      general = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more

        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";

        layout = "dwindle";
      };

      decoration = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more

        rounding = 10;
        # blur = true
        # blur_size = 3
        # blur_passes = 1
        # blur_new_optimizations = true

        drop_shadow = true;
        shadow_range = 4;
        shadow_render_power = 3;
        "col.shadow" = "rgba(1a1a1aee)";
      };

      animations = {
          enabled = true;

          # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

          bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

          animation = [
            "windows, 1, 7, myBezier"
            "windowsOut, 1, 7, default, popin 80%"
            "border, 1, 10, default"
            "borderangle, 1, 8, default"
            "fade, 1, 7, default"
            "workspaces, 1, 6, default"
          ];
      };

      dwindle = {
          # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
          pseudotile = true; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
          preserve_split = true; # you probably want this
      };

      master = {
          # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
          new_is_master = true;
      };

      gestures = {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more
          workspace_swipe = false;
      };

      # Example per-device config
      # See https://wiki.hyprland.org/Configuring/Keywords/#per-device-input-configs for more
      "device:epic-mouse-v1" = {
          sensitivity = "-0.5";
      };

      "$mainMod" = "SUPER";
      bind = [
        # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
        "$mainMod, Q, exec, kitty"
        "$mainMod, C, killactive,"
        "$mainMod, M, exit,"
        "$mainMod, E, exec, dolphin"
        "$mainMod, V, togglefloating,"
        "$mainMod, R, exec, wofi --show drun"
        "$mainMod, P, pseudo," # dwindle
        "$mainMod, J, togglesplit," # dwindle

        # Move focus with mainMod + arrow keys
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"

        # Scroll through existing workspaces with mainMod + scroll
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"

        # Custom binds
        "$mainMod SHIFT, E, exec, code"
        "$mainMod SHIFT, B, exec, vivaldi"
        "$mainMod SHIFT, N, exec, nmcli c up 6bc7eef3-6dde-483f-ab31-69189be41639"
        "$mainMod SHIFT, M, exec, nmcli c down 6bc7eef3-6dde-483f-ab31-69189be41639"
        "$mainMod ALT, H, workspace, r-1"
        "$mainMod ALT, J, workspace, empty"
        "$mainMod ALT, K, workspace, 1"
        "$mainMod ALT, L, workspace, r+1"
        "$mainMod ALT, left, workspace, r-1"
        "$mainMod ALT, down, workspace, empty"
        "$mainMod ALT, up, workspace, 1"
        "$mainMod ALT, right, workspace, r+1"
      ] ++ (
        builtins.concatLists (
          builtins.genList (
            x: let
              ws = let
                c = (x + 1) / 10;
              in
                builtins.toString (x + 1 - (c * 10));
            in [
              "$mainMod, ${ws}, workspace, ${toString (x + 1)}"
              "$mainMod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
            ]
          )
          10
        )
      );
    };
  };
  # dconf.settings = {
  #   "org/gnome/desktop/input-sources" = with lib.hm.gvariant; {
  #     show-all-sources = true;
  #     sources = [
  #       (mkTuple [ "xkb" "us+altgr-intl" ])
  #       #(mkTuple [ "xkb" "us" ])
  #     ];
  #     xkb-options = [
  #       "terminate:ctrl_alt_bksp"
  #     ];
  #   };
  #   "org/gnome/settings-daemon/plugins/media-keys" = {
  #     custom-keybindings = [
  #       "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
  #       "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
  #       "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
  #       "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/"
  #       "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/"
  #     ];
  #   };
  #   "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
  #     binding="<Super>t";
  #     command="kgx";
  #     name="Open Terminal";
  #   };
  #   "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
  #     binding="<Super>e";
  #     command="code";
  #     name="Open VSCode";
  #   };
  #   "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
  #     binding="<Super>b";
  #     command="vivaldi";
  #     name="Open Vivaldi";
  #   };
  #   "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
  #     binding="<Super><Shift>n";
  #     command="nmcli c up 6bc7eef3-6dde-483f-ab31-69189be41639";
  #     name="Enable VPN";
  #   };
  #   "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4" = {
  #     binding="<Super><Shift>m";
  #     command="nmcli c down 6bc7eef3-6dde-483f-ab31-69189be41639";
  #     name="Disable VPN";
  #   };
  #   # "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
  #   #   binding="<Super>e";
  #   #   command="emacsclient -c -a 'emacs'";
  #   #   name="Open emacs client";
  #   # };
  # };
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