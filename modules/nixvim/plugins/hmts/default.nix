{ config, ... }:
{
  plugins = {
    hmts = {
      inherit (config.plugins.treesitter) enable;

      lazyLoad.settings.ft = "nix";
    };
  };
}
