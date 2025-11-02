{ config, lib, ... }:
{
  plugins.mini-cursorword =
    lib.mkIf (config.khanelivim.ui.referenceHighlighting == "mini-cursorword")
      {
        enable = true;
        settings = {
          delay = 100; # Delay in milliseconds before highlighting
        };
      };
}
