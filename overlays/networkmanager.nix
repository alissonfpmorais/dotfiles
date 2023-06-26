nixpkgs: self: super:
let
  lib = nixpkgs.lib;
  rem = index: arr: lib.remove index arr;
  remLast = arr: rem (lib.length arr) arr;
in
{
  networkmanager = super.networkmanager.overrideAttrs (oldAttrs: rec {
    version = "1.38.4";

    src = fetchurl {
      url = "mirror://gnome/sources/NetworkManager/${lib.versions.majorMinor version}/NetworkManager-${version}.tar.xz";
      sha256 = "sha256-hB9k1Bd2qt2SsVH0flD2K+igYRqQVv5r+BiBAk5qlsU=";
    };

    mesonFlags = remLast oldAttrs.mesonFlags;

    patches = remLast oldAttrs.patches;

    nativeBuildInputs = rem 3 (
      rem 7 oldAttrs.nativeBuildInputs
    ) ++ [
      super.intltool
    ];
  });
}
