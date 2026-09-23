{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.plugbench.plumber;

  start = pkgs.writeShellScript "plugbench-plumber" ''
    ${config.plugbench.tokenPrefix} exec ${pkgs.plumber-pluggo}/bin/plumber
  '';
in {
  config = mkIf cfg.enable {
    systemd.user.services.plugbench-plumber = {
      enable = true;
      after = [ "network.target" ];
      wantedBy = [ "default.target" ];
      description = "Plugbench Plumber";
      serviceConfig = {
        Type = "simple";
        ExecStart = "${start}";
        Restart = "always";
        RestartSec = "5";
      };
    };
  };
}

