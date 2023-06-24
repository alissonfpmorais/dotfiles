self: super:

{
  networkmanager-openvpn = super.networkmanager-openvpn.overrideAttrs (oldAttrs: rec {
    version = "1.8.18";

    src = super.fetchurl {
      url = "https://download.gnome.org/sources/NetworkManager-openvpn/${builtins.substring 0 3 version}/NetworkManager-openvpn-${version}.tar.xz";
      sha256 = "U9+wrPZEeK3HKAdPFi9i5gv/YqYFvYl+uIsmfnBXkno=";
    };

    buildInputs = oldAttrs.buildInputs ++ [ super.intltool ];
  });
}
