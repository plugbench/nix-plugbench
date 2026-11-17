{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.plugbench.sigils;
in {
  options.plugbench.sigils = {
    enable = mkEnableOption "plugbench sigils";

    package = mkOption {
      type = types.package;
      readOnly = true;
      description = ''
        The sigils-pluggo package, for window managers to start `sigils`
        from.
      '';
    };
  };

  config = mkMerge [
    {
      plugbench.sigils.package = pkgs.sigils-pluggo;
    }
    (mkIf cfg.enable {
      environment.systemPackages = [ cfg.package ];
    })
  ];
}
