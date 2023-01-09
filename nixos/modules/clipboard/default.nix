{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.plugbench.clipboard;
in {
  config = mkIf cfg.enable {
    services.x11.displayManager.sessionCommands = ''
      ${pkgs.clipboard-pluggo}/bin/clipboard &
    '';
  };
}
