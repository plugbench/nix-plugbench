{ config, lib, pkgs, ... }:

with lib;
let
  token = config.plugbench.token;
  cfg = config.plugbench.plumber;
in {
  config = mkIf cfg.enable {
    systemd.user.services.plugbench-plumber = {
      enable = true;
      after = [ "network.target" ];
      wantedBy = [ "default.target" ];
      description = "Plugbench Plumber";
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.plumber-pluggo}/bin/plumber";
        Environment = optionalAttrs (token != null) {
          NATS_TOKEN = token;
        };
        Restart = "always";
        RestartSec = "5";
      };
    };
  };
}

