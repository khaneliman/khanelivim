{ config, ... }:
{
  plugins = {
    hmts = {
      inherit (config.plugins.treesitter) enable;
    };
  };
}
