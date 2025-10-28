{ config, lib, ... }:
{
  plugins.helpview = {
    enable = lib.elem "helpview" config.khanelivim.documentation.viewers;

    lazyLoad.settings.ft = "help";

    settings = {

      buf_ignore = [ ];

      mode = [
        "n"
        "x"
        "i"
        "r"
      ];

      hybrid_modes = [
        "i"
        "r"
      ];
    };
  };
}
