{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.plugbench.plumber;
in {
  config = mkIf cfg.enable {
    launchd.user.agents.plugbench-plumber = {
      script = ''
        ${config.plugbench.tokenPrefix} exec ${pkgs.plumber-pluggo}/bin/plumber
      '';
      serviceConfig = {
        KeepAlive = true;
      };
    };
  };
}
