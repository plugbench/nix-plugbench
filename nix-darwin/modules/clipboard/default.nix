{ config, lib, pkgs, options, ... }:

with lib;
let
  cfg = config.plugbench.clipboard;
in {
  options.plugbench.clipboard.enable = mkEnableOption "plugbench clipboard";

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.clipboard-pluggo ];

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
