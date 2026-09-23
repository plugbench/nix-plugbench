{ lib, pkgs, config, ... }:

with lib;
{
  imports = [
    ./clipboard
    ./kakoune
    ./plumber
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
        File containing the token used to connect, with no trailing newline
        or surrounding whitespace.  Read each time a pluggo starts, so the
        token never enters the Nix store -- this is what you want with
        agenix and friends.

        Takes precedence over {option}`plugbench.token` when both are set.
      '';
      type = types.nullOr types.path;
    };

    plugbench.tokenPrefix = mkOption {
      internal = true;
      readOnly = true;
      type = types.str;
      description = ''
        `NATS_TOKEN=...` assignment to prefix a pluggo command line with, or
        the empty string when no token is configured.  Resolves the
        {option}`plugbench.token` / {option}`plugbench.tokenFile` precedence
        in one place so each pluggo doesn't have to.

        Beware that this may contain a command substitution: only use it in
        a context that a shell will evaluate, and keep it out of anything
        world-readable if it came from {option}`plugbench.token`.
      '';
    };
  };

  config = {
    plugbench.tokenPrefix =
      if config.plugbench.tokenFile != null
      then ''NATS_TOKEN="$(${pkgs.coreutils}/bin/cat ${escapeShellArg config.plugbench.tokenFile})"''
      else if config.plugbench.token != null
      then "NATS_TOKEN=${escapeShellArg config.plugbench.token}"
      else "";
  };
}
