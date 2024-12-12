_: _final: prev: {
  vimPlugins = prev.vimPlugins // {
    snacks-nvim = prev.vimPlugins.snacks-nvim.overrideAttrs {
      pname = "snacks.nvim";
      version = "2.9.0";
      src = prev.fetchFromGitHub {
        owner = "folke";
        repo = "snacks.nvim";
        tag = "v2.9.0";
        hash = "sha256-szno2o0qhclp/uVqSME0ssSDORwLkpHWqom27EvDklU=";
      };
      meta.homepage = "https://github.com/folke/snacks.nvim/";
    };
  };
}
