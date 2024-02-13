{ config, lib, pkgs, options, ... }:

with lib;
let
  token = config.plugbench.token;
  cfg = config.plugbench.clipboard;
in {
  config = mkIf cfg.enable {
    launchd.user.agents.plugbench-clipboard = {
      script = ''
        ${pkgs.clipboard-pluggo}/bin/clipboard
      '';
      environment.NIX_TOKEN = mkIf (token != null) token;
      serviceConfig = {
        KeepAlive = true;
        StandardOutPath = "/tmp/clipboard.out";
        StandardErrorPath = "/tmp/clipboard.err";
      };
    };
  };
}
