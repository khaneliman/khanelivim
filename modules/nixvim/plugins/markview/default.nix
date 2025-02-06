{ pkgs, ... }:
{
  plugins.markview = {
    enable = true;
    package = pkgs.vimPlugins.markview-nvim.overrideAttrs {
      version = "2025-01-30";
      src = pkgs.fetchFromGitHub {
        owner = "OXY2DEV";
        repo = "markview.nvim";
        rev = "f933b4597738fec4014d25f11511bcbe2d1e1a32";
        hash = "sha256-V3imWAzPtlrC89CYigDvnye12CctM7RJioigc57Rn/8=";
        fetchSubmodules = true;
      };
      doCheck = false;
    };

    lazyLoad.settings.ft = "markdown";

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
