{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.de.gnome;
in
{
  options.modules.de.gnome = {
    enable = mkEnableOption "Enable Gnome DE";
  };

  config = mkIf cfg.enable {
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = true;

    home-manager.users.alissonfpmorais =
      { lib, ... }:
      {
        dconf.settings = {
          "org/gnome/desktop/input-sources" = with lib.hm.gvariant; {
            show-all-sources = true;
            sources = [
              (mkTuple [
                "xkb"
                "us+altgr-intl"
              ])
              #(mkTuple [ "xkb" "us" ])
            ];
            xkb-options = [
              "terminate:ctrl_alt_bksp"
            ];
          };
          "org/gnome/settings-daemon/plugins/media-keys" = {
            custom-keybindings = [
              "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
              "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
              "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
              "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/"
              "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/"
            ];
          };
          "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
            binding = "<Super>q";
            command = if config.modules.general.kitty.enable then "kitty" else "kgx";
            name = "Open Terminal";
          };
          "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
            binding = "<Shift><Super>e";
            command = "code";
            name = "Open VSCode";
          };
          "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
            binding = "<Shift><Super>b";
            command = "vivaldi";
            name = "Open Vivaldi";
          };
          # "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
          #   binding="<Super><Shift>n";
          #   command="nmcli c up 6bc7eef3-6dde-483f-ab31-69189be41639";
          #   name="Enable VPN";
          # };
          # "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4" = {
          #   binding="<Super><Shift>m";
          #   command="nmcli c down 6bc7eef3-6dde-483f-ab31-69189be41639";
          #   name="Disable VPN";
          # };
          # "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
          #   binding="<Super>e";
          #   command="emacsclient -c -a 'emacs'";
          #   name="Open emacs client";
          # };
        };
      };
  };
}
