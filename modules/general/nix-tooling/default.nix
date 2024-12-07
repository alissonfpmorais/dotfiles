{
  config,
  lib,
  nixpkgs,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.general.nix-tooling;
in
{
  options.modules.general.nix-tooling = {
    enable = mkEnableOption "Enable nix tooling";
  };

  config = mkIf cfg.enable {
    nix.nixPath = [ "nixpkgs=${nixpkgs}" ];

    users.users.alissonfpmorais.packages = with pkgs; [
      nixd
      nixfmt-rfc-style
    ];
  };
}
