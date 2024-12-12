_: _final: prev: {
  vimPlugins = prev.vimPlugins // {
    lazy-nvim = prev.vimPlugins.lazy-nvim.overrideAttrs {
      version = "11.16.1";
      src = prev.fetchFromGitHub {
        owner = "folke";
        repo = "lazy.nvim";
        tag = "v11.16.1";
        hash = "sha256-ggseHUfnMiUnyFia9driFzz7civjn/9TG8aIQLU+N4A=";
      };
    };
  };
}
