_: _final: prev: {
  vimPlugins = prev.vimPlugins // {
    snacks-nvim = prev.vimPlugins.snacks-nvim.overrideAttrs {
      pname = "snacks.nvim";
      version = "2024-12-10";
      src = prev.fetchFromGitHub {
        owner = "folke";
        repo = "snacks.nvim";
        rev = "c9880ce872ca000d17ae8d62b10e913045f54735";
        sha256 = "100vzbx2h6w939r8wdis8i2zyqnfc64rg4zaiifz6yj3h17fja6a";
      };
      meta.homepage = "https://github.com/folke/snacks.nvim/";
    };
  };
}
