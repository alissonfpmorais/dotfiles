{ nixpkgs, ... }@inputs:
{
  nixpkgs.overlays = [
    # (import ../../overlays/emacs inputs)
    (import ../../overlays/fcitx-engines inputs)
    (import ../../overlays/networkmanager-openvpn inputs)
  ];
}