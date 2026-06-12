{ lib, ... }:
{
  plugins = {
    # sqlite.lua documentation
    # See: https://github.com/kkharji/sqlite.lua
    sqlite-lua.enable = lib.mkDefault true;
  };
}
