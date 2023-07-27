{ lib, pkgs, ... }:
{
  home.stateVersion = "22.11";
  dconf.settings = {
    "org/gnome/desktop/input-sources" = with lib.hm.gvariant; {
      show-all-sources = true;
      sources = [
        (mkTuple [ "xkb" "us+altgr-intl" ])
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