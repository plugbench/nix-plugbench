{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.plugbench.fre;
in {
  options.plugbench.fre = {
    enable = mkEnableOption "plugbench frecency store";
    client = mkEnableOption "plugbench frecency store client";
  };

  config = mkIf (cfg.enable || cfg.client) {
    environment.systemPackages = [ pkgs.fre-pluggo ];
  };
}
