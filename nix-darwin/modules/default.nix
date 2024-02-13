{ lib, ... }:

with lib;
{
  imports = [
    ./clipboard
    ./plumber
  ];
}
