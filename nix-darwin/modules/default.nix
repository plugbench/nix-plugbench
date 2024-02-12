{ lib, ... }:

with lib;
{
  imports = [
    ./clipboard
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
