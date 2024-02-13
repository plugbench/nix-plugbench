{ config, lib, pkgs, ... }:

with lib;
let
  token = config.plugbench.token;
  cfg = config.plugbench.plumber;
in {
  config = mkIf cfg.enable {
    launchd.user.agents.plugbench-plumber = {
      script = ''
        ${pkgs.plumber-pluggo}/bin/plumber
      '';
      environment.NATS_TOKEN = mkIf (token != null) token;
      serviceConfig = {
        KeepAlive = true;
      };
    };
  };
}
