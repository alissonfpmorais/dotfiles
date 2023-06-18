{ pkgs ? import <nixpkgs> {} }:

let
    emacs = (pkgs.emacs.override {}).overrideAttrs (attrs: {
        postInstall = (attrs.postInstall or "") + ''
            rm $out/share/applications/emacs.desktop
            export PATH="$PATH:$HOME/.config/emacs/bin/"
        '';
    });
in
emacs
