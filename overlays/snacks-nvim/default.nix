_: _final: prev: {
  vimPlugins = prev.vimPlugins // {
    snacks-nvim = prev.vimPlugins.snacks-nvim.overrideAttrs {
      pname = "snacks.nvim";
      version = "2024-12-01";
      src = prev.fetchFromGitHub {
        owner = "folke";
        repo = "snacks.nvim";
        rev = "5f768f8584e5247e3283201bfa068fa394ed0c4b";
        sha256 = "05pf9ljs8xwnbqd6zdgfgv386pjmj8k4y0mjdb815fkik428sm3w";
      };
      meta.homepage = "https://github.com/folke/snacks.nvim/";
    };
  };
}
