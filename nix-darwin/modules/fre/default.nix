{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.plugbench.fre;
in {
  config = mkIf cfg.enable {
    launchd.user.agents.plugbench-fre = {
      script = ''
        ${config.plugbench.tokenPrefix} exec ${pkgs.fre-pluggo}/bin/fre-pluggo daemon
      '';
      serviceConfig = {
        KeepAlive = true;
      };
    };
  };
}
