{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.plugbench.plumber;
in {
  options.plugbench.plumber.enable = mkEnableOption "plugbench plumber";

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.plumber-pluggo ];
  };
}
