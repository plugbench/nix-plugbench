{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.plugbench.clipboard;
in {
  config = mkIf cfg.enable {
    services.xserver.displayManager.sessionCommands = ''
      ${config.plugbench.tokenPrefix} ${pkgs.clipboard-pluggo}/bin/clipboard &
    '';
  };
}
