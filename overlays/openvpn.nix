nixpkgs: self: super:

{
  openvpn = super.openvpn.overrideAttrs (oldAttrs: rec {
    version = "2.5.0";
    
    src = super.fetchurl {
      url = "https://swupdate.openvpn.org/community/releases/openvpn-${version}.tar.xz";
      sha256 = "AppCbkTWVstOEYkxnJX+b8mGQkdyT1WZ2Z35xMNHj70=";
    };
  });
}