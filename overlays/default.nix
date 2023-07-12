{ nixpkgs, ... }@inputs:
{
  nixpkgs.overlays = [
    (import ./openvpn inputs)
  ];
}