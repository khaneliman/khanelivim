{ lib, pkgs, ... }:
{
  extraPlugins = [ pkgs.vimPlugins.lzn-auto-require ];

  extraConfigLuaPost = lib.mkOrder 5000 ''
    require('lzn-auto-require').enable()
  '';

  plugins.lz-n.enable = true;
}
