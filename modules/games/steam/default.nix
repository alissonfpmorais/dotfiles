{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.games.steam;
in
{
  options.modules.games.steam = {
    enable = mkEnableOption "Enable Steam";
  };

  config = mkIf cfg.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    };

    users.users.alissonfpmorais.packages = with pkgs; [
      steam-tui
    ];
  };
}