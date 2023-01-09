{ config, lib, pkgs, options, ... }:

with lib;
let
  cfg = config.plugbench.clipboard;
in {
  config = mkIf cfg.enable {
    launchd.user.agents.plugbench-clipboard = {
      script = ''
        ${pkgs.clipboard-pluggo}/bin/clipboard
      '';
      serviceConfig = {
        KeepAlive = true;
      };
    };
  };
}
