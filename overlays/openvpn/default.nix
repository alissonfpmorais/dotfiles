{ nixpkgs-openvpn, system, ... }:
let
  ovpnPkgs = import nixpkgs-openvpn {
    inherit system;
    config.allowUnfree = true;
  };
in
(final: prev: {
  networkmanager-openvpn = ovpnPkgs.networkmanager-openvpn;
})