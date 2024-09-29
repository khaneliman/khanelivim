{ pkgs, ... }:
{
  plugins.markview = {
    enable = true;
    package = pkgs.vimPlugins.markview-nvim.overrideAttrs (_oldAttrs: {
      dependencies = [ ];
    });

    settings = {
      buf_ignore = [ ];

      modes = [
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
