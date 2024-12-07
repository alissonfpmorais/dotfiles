{
  config,
  hyprland,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.de.hyprland;
  wallpaperPath = pkgs.runCommand "wallpaper" { } ''
    mkdir -p $out
    cp ${./wallpaper1.jpg} $out/wallpaper1.jpg
  '';
in
# iconsSetup = pkgs.runCommand "icons" {} ''
#   cp -R cursor-themes ~/.local/share/icons
# '';
{
  options.modules.de.hyprland = {
    enable = mkEnableOption "Enable Hyprland (and a bunch of other stuff) to work as a DE";
  };

  config = mkIf cfg.enable {
    services.xserver.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };

    # Hint electron apps to use wayland:
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    environment.systemPackages = [
      pkgs.hyprcursor
      pkgs.hyprlang
      # pkgs.hyprlock
      pkgs.hyprpaper
      pkgs.hyprpolkitagent
      pkgs.libsForQt5.qt5.qtwayland
      pkgs.nwg-look
    ];

    programs.hyprland = {
      enable = true;
      # set the flake package
      package = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      # make sure to also set the portal package, so that they are in sync
      portalPackage = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };

    home-manager.users.alissonfpmorais = {
      home.file.".config/hypr/hyprpaper.conf".text = ''
        preload = ${wallpaperPath}/wallpaper1.jpg
        wallpaper = ,${wallpaperPath}/wallpaper1.jpg
        ipc = off
      '';

      home.file.".local/share/icons" = {
        source = ./cursor-themes;
        recursive = true;
      };

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
        # set the flake package
        package = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
        plugins = [
          # pkgs.hyprlandPlugins.<plugin>
        ];
        settings = {
          # See https://wiki.hyprland.org/Configuring/Monitors/
          #hyprctl monitors all
          #monitor=name,resolution,position,scale
          #monitor=DP-1,1920x1080@144,0x0,1
          monitor = [
            # "eDP-1,preferred,auto,1"
            # "HDMI-A-3,preferred,auto,1,mirror,eDP-1"
            "HDMI-A-3,preferred,auto,1"
          ];

          # See https://wiki.hyprland.org/Configuring/Keywords/ for more

          # Execute your favorite apps at launch
          # exec-once = waybar & hyprpaper & firefox
          # exec-once = "hyprpaper";
          exec-once = [
            "hyprpaper"
            "systemctl --user start hyprpolkitagent"
            "hyprctl setcursor "
          ];

          # Source a file (multi-file configs)
          # source = ~/.config/hypr/myColors.conf

          # Some default env vars.
          env = [
            "XCURSOR_SIZE,32"

            # Ensure cursor is loaded correctly
            "WLR_NO_HARDWARE_CURSORS,1"

            # Ensure keyring works properly
            # "GNOME_KEYRING_CONTROL,/run/user/1000/keyring"
            # "SSH_AUTH_SOCK,/run/user/1000/keyring/ssh"

            # Setup cursor themes
            "HYPRCURSOR_THEME,Bibata-Modern-Ice"
            "HYPRCURSOR_SIZE,24"
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

            shadow = {
              enabled = true;
              color = "rgba(1a1a1aee)";
              range = 4;
              render_power = 3;
            };
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

          gestures = {
            # See https://wiki.hyprland.org/Configuring/Variables/ for more
            workspace_swipe = false;
          };

          # Example per-device config
          # See https://wiki.hyprland.org/Configuring/Keywords/#per-device-input-configs for more
          device = {
            name = "epic-mouse-v1";
            sensitivity = "-0.5";
          };

          "$mainMod" = "SUPER";
          bind =
            [
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
              "$mainMod, code:107, exec, grim -g \"$(slurp)\" - | swappy -f -"
              "$mainMod SHIFT, B, exec, vivaldi"
              "$mainMod SHIFT, D, exec, dbeaver"
              "$mainMod SHIFT, E, exec, code"
              "$mainMod SHIFT, F, exec, microsoft-edge"
              "$mainMod SHIFT, M, exec, nmcli c down 6bc7eef3-6dde-483f-ab31-69189be41639"
              "$mainMod SHIFT, N, exec, nmcli c up 6bc7eef3-6dde-483f-ab31-69189be41639"

              "$mainMod ALT, H, workspace, r-1"
              "$mainMod ALT, J, workspace, empty"
              "$mainMod ALT, K, workspace, 1"
              "$mainMod ALT, L, workspace, r+1"
              "$mainMod SHIFT, H, movetoworkspace, r-1"
              "$mainMod SHIFT, L, movetoworkspace, r+1"
              "$mainMod CTRL, H, movewindow, l"
              "$mainMod CTRL, J, movewindow, d"
              "$mainMod CTRL, K, movewindow, u"
              "$mainMod CTRL, L, movewindow, r"

              "$mainMod ALT, left, workspace, r-1"
              "$mainMod ALT, down, workspace, empty"
              "$mainMod ALT, up, workspace, 1"
              "$mainMod ALT, right, workspace, r+1"
              "$mainMod SHIFT, left, movetoworkspace, r-1"
              "$mainMod SHIFT, right, movetoworkspace, r+1"
              "$mainMod CTRL, left, movewindow, l"
              "$mainMod CTRL, down, movewindow, d"
              "$mainMod CTRL, up, movewindow, u"
              "$mainMod CTRL, right, movewindow, r"
            ]
            ++ (builtins.concatLists (
              builtins.genList (
                x:
                let
                  ws =
                    let
                      c = (x + 1) / 10;
                    in
                    builtins.toString (x + 1 - (c * 10));
                in
                [
                  "$mainMod, ${ws}, workspace, ${toString (x + 1)}"
                  "$mainMod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
                ]
              ) 10
            ));

          binde = [
            "$mainMod CTRL ALT, H, resizeactive, -10 0"
            "$mainMod CTRL ALT, J, resizeactive, 0 10"
            "$mainMod CTRL ALT, K, resizeactive, 0 -10"
            "$mainMod CTRL ALT, L, resizeactive, 10 0"

            "$mainMod CTRL ALT, left, resizeactive, -10 0"
            "$mainMod CTRL ALT, down, resizeactive, 0 10"
            "$mainMod CTRL ALT, up, resizeactive, 0 -10"
            "$mainMod CTRL ALT, right, resizeactive, 10 0"
          ];
          bindel = [
            ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
            ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ];
          bindl = [
            ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ];
        };
      };
    };
  };
}
