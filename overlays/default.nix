{ nixpkgs, ... }@inputs:
{
  nixpkgs.overlays = [
    (import ./fcitx-engines inputs)
    (import ./openvpn inputs)
  ];
}