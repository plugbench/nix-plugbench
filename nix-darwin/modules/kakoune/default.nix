{ config, lib, pkgs, options, ... }:

with lib;
let
  cfg = config.plugbench.kakoune;
in {
  options.plugbench.kakoune.enable = mkEnableOption "plugbench kakoune";

  config = mkIf cfg.enable {
    launchd.user.agents.plugbench-kakoune = {
      script = ''
        ${pkgs.kakoune-pluggo}/bin/kakoune-editor-service
      '';
      serviceConfig = {
        KeepAlive = true;
      };
    };
  };

}
