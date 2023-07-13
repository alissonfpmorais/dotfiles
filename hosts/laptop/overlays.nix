{ nixpkgs, ... }@inputs:
{
  nixpkgs.overlays = [
    (import ../../overlays/fcitx-engines inputs)
    (import ../../overlays/openvpn inputs)
  ];
}