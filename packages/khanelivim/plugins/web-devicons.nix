{ config, lib, ... }:
{
  plugins = {
    web-devicons = {
      enable = config.plugins.mini.enable && lib.hasAttr "icons" config.plugins.mini;
    };
  };
}
