{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.plugbench.clipboard;
in {
  options.plugbench.clipboard.enable = mkEnableOption "plugbench clipboard";

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.clipboard-pluggo ];
  };
}
