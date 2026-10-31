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
        `sigils`, with the token.  Window managers, which start it, don't
        usually have the token in their environment.
      '';
    };
  };

  config = mkMerge [
    {
      plugbench.sigils.package = pkgs.writeShellScriptBin "sigils" ''
        ${config.plugbench.tokenPrefix} exec ${pkgs.sigils-pluggo}/bin/sigils "$@"
      '';
    }
    (mkIf cfg.enable {
      environment.systemPackages = [ cfg.package ];
    })
  ];
}
