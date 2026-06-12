{ lib, ... }:
{
  plugins = {
    mini-fuzzy.enable = lib.mkDefault true;
  };
}
