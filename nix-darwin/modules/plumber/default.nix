{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.plugbench.plumber;
in {
  config = mkIf cfg.enable {
    launchd.user.agents.plugbench-plumber = {
      script = ''
        ${pkgs.plumber-pluggo}/bin/plumber
      '';
      serviceConfig = {
        KeepAlive = true;
      };
    };
  };

}
