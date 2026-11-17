{ lib, config, ... }:

with lib;
let
  cfg = config.plugbench;

  pluggos = [
    "clipboard-pluggo"
    "fre-pluggo"
    "kakoune-pluggo"
    "plumber-pluggo"
    "sigils-pluggo"
  ];

  tokenExport = pkgs:
    if cfg.tokenFile != null
    then ''export NATS_TOKEN="$(${pkgs.coreutils}/bin/cat ${escapeShellArg cfg.tokenFile})"''
    else "export NATS_TOKEN=${escapeShellArg cfg.token}";

  withToken = pkgs: pkg: pkgs.symlinkJoin {
    inherit (pkg) name;
    paths = [ pkg ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      for prog in "$out"/bin/*; do
        wrapProgram "$prog" --run ${escapeShellArg (tokenExport pkgs)}
      done
    '';
  };
in
{
  imports = [
    ./clipboard
    ./fre
    ./kakoune
    ./plumber
    ./sigils
  ];

  options = {
    plugbench.token = mkOption {
      default = null;
      description = ''
        token used to connect.

        This ends up in the world-readable Nix store; prefer
        {option}`plugbench.tokenFile` for anything secret.
      '';
      type = types.nullOr types.str;
    };

    plugbench.tokenFile = mkOption {
      default = null;
      example = "/run/agenix/nats-token";
      description = ''
        File containing the token used to connect, on its own; a trailing
        newline is fine.  Read each time a pluggo starts, so the token never
        enters the Nix store -- this is what you want with agenix and
        friends.

        Takes precedence over {option}`plugbench.token` when both are set.
      '';
      type = types.nullOr types.path;
    };
  };

  config = {
    # Every pluggo gets the token, however it is started: from a shell, by a
    # service manager, or by a window manager or editor whose environment
    # doesn't have it.
    nixpkgs.overlays = mkIf (cfg.tokenFile != null || cfg.token != null) (mkAfter [
      (final: prev: genAttrs pluggos (name: withToken final prev.${name}))
    ]);
  };
}
