{ lib, ... }:

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
      '';
      type = types.nullOr types.str;
    };
  };
}

