{ lib, pkgs, ... }:
{
  home.stateVersion = "23.11";
  # wayland.windowManager.hyprland = {
  #   enable = true;
  #   settings = {
  #     "$mod" = "SUPER";
  #     bind = [
  #       "$mod, T, exec, kgx"
  #     ] ++ (
  #       builtins.concatLists (
  #         builtins.genList (
  #           x: let
  #             ws = let
  #               c = (x + 1) / 10;
  #             in
  #               builtins.toString (x + 1 - (c * 10));
  #           in [
  #             "$mod, ${ws}, workspace, ${toString (x + 1)}"
  #             "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
  #           ]
  #         )
  #         10
  #       )
  #     );
  #   };
  # };
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
}