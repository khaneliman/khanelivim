{
  config,
  lib,
  pkgs,
  ...
}:
{
  extraPlugins = lib.mkIf config.plugins.lz-n.enable [ pkgs.vimPlugins.lzn-auto-require ];

  extraConfigLuaPost = lib.mkIf config.plugins.lz-n.enable (
    lib.mkOrder 5000 ''
      require('lzn-auto-require').enable()
    ''
  );

  plugins.lz-n.enable = true;
}
