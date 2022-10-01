{ config, lib, pkgs, options, ... }:

with lib;
let
  cfg = config.plugbench.kakoune;
in {
  options.plugbench.kakoune.enable = mkEnableOption "plugbench kakoune";

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.kakoune-pluggo ];

    launchd.user.agents.plugbench-kakoune = {
      path = [ pkgs.kakoune ];
      script = ''
        ${pkgs.kakoune-pluggo}/bin/kakoune-editor-service
      '';
      serviceConfig = {
        KeepAlive = true;
      };
    };
  };

}
