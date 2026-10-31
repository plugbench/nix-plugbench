{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.plugbench.fre;

  start = pkgs.writeShellScript "plugbench-fre" ''
    ${config.plugbench.tokenPrefix} exec ${pkgs.fre-pluggo}/bin/fre-pluggo daemon
  '';
in {
  config = mkIf cfg.enable {
    systemd.user.services.plugbench-fre = {
      enable = true;
      after = [ "network.target" ];
      wantedBy = [ "default.target" ];
      description = "Plugbench Frecency Store";
      serviceConfig = {
        Type = "simple";
        ExecStart = "${start}";
        Restart = "always";
        RestartSec = "5";
      };
    };
  };
}
