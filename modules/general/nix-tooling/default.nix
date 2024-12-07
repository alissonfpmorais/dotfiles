{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.general.nix-tooling;
in
{
  options.modules.general.nix-tooling = {
    enable = mkEnableOption "Enable nix tooling";
  };

  config = mkIf cfg.enable {
    users.users.alissonfpmorais.packages = with pkgs; [
      nixfmt-rfc-style
    ];
  };
}