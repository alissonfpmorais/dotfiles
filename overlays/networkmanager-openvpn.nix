nixpkgs: self: super:
let
  lib = nixpkgs.lib;
  rem = index: arr: lib.remove index arr;
in
{
  networkmanager-openvpn = super.networkmanager-openvpn.overrideAttrs (oldAttrs: rec {
    version = "1.8.18";

    src = super.fetchurl {
      url = "https://download.gnome.org/sources/${oldAttrs.pname}/${nixpkgs.lib.versions.majorMinor version}/${oldAttrs.pname}-${version}.tar.xz";
      sha256 = "U9+wrPZEeK3HKAdPFi9i5gv/YqYFvYl+uIsmfnBXkno=";
    };

    nativeBuildInputs = rem 1 oldAttrs.nativeBuildInputs ++ [
      super.intltool
    ];

    buildInputs = rem 1 (
      rem 2 oldAttrs.buildInputs
    ) ++ [
      self.openvpn
      self.networkmanager
    ];
  });
}
