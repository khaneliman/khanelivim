{ pkgs, ... }:
{
  plugins.markview = {
    enable = true;
    package = pkgs.vimPlugins.markview-nvim.overrideAttrs {
      version = "2025-01-27";
      src = pkgs.fetchFromGitHub {
        owner = "OXY2DEV";
        repo = "markview.nvim";
        rev = "81b40bd8c8c9e239bd14f7dace29f64fe20cbb98";
        sha256 = "1rc4l1gwva0qhdhdnqn2l1nmwh8s86vij45j27xkq9fgxpffbx2i";
        fetchSubmodules = true;
      };
      doCheck = false;
    };

    settings = {
      buf_ignore = [ ];

      preview = {
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
  };
}
