{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.plugbench.plumber;
in {
  options.plugbench.plumber = {
    enable = mkEnableOption "plugbench plumber";
    client = mkEnableOption "plugbench client";
  };

  config = mkIf (cfg.enable || cfg.client) {
    environment.systemPackages = [ pkgs.plumber-pluggo ];
  };
}
