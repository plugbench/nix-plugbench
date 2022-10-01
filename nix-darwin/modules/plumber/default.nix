{ config, lib, pkgs, options, ... }:

with lib;
let
  cfg = config.plugbench.plumber;
in {
  options.plugbench.plumber.enable = mkEnableOption "plugbench plumber";

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
