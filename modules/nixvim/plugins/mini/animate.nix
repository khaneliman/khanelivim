{ config, lib, ... }:
{
  plugins.mini-animate = lib.mkIf (config.khanelivim.ui.animations == "mini-animate") {
    enable = true;
    settings = {
      cursor = {
        enable = true;
        timing.__raw = "require('mini.animate').gen_timing.linear({ duration = 100, unit = 'total' })";
      };
      scroll = {
        enable = true;
        timing.__raw = "require('mini.animate').gen_timing.linear({ duration = 150, unit = 'total' })";
      };
      resize = {
        enable = true;
        timing.__raw = "require('mini.animate').gen_timing.linear({ duration = 100, unit = 'total' })";
      };
      open = {
        enable = true;
        timing.__raw = "require('mini.animate').gen_timing.linear({ duration = 150, unit = 'total' })";
      };
      close = {
        enable = true;
        timing.__raw = "require('mini.animate').gen_timing.linear({ duration = 150, unit = 'total' })";
      };
    };
  };
}
