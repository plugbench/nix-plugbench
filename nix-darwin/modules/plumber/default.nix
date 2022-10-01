{ config, lib, pkgs, options, ... }:

with lib;
let
  cfg = config.plugbench.plumber;
in {
  options.plugbench.plumber.enable = mkEnableOption "plugbench plumber";

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.plumber-pluggo ];

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
