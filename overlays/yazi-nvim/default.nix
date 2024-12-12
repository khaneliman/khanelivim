_: _final: prev: {
  vimPlugins = prev.vimPlugins // {
    yazi-nvim = prev.vimPlugins.yazi-nvim.overrideAttrs {
      pname = "yazi.nvim";
      version = "6.9.0";
      src = prev.fetchFromGitHub {
        owner = "mikavilpas";
        repo = "yazi.nvim";
        tag = "v6.9.0";
        hash = "sha256-GIBXiHGW+7aKOR6c3mkJz05CdewFE9gAhbbvIZcxiEc=";
      };
      meta.homepage = "https://github.com/mikavilpas/yazi.nvim/";
    };
  };
}
