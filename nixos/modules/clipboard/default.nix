{ config, lib, pkgs, ... }:

with lib;
let
  tokenVar = if config.plugbench.token == null;
             then ""
             else "NIX_TOKEN=" + (escapeShellArg token);
  cfg = config.plugbench.clipboard;
in {
  config = mkIf cfg.enable {
    services.xserver.displayManager.sessionCommands = ''
      ${tokenVar} ${pkgs.clipboard-pluggo}/bin/clipboard &
    '';
  };
}
