_: _final: prev: {
  vimPlugins = prev.vimPlugins // {
    lazy-nvim = prev.vimPlugins.lazy-nvim.overrideAttrs {
      version = "0000000013042343";
      src = prev.fetchFromGitHub {
        owner = "folke";
        repo = "lazy.nvim";
        rev = "3388a26417c48b15d5266d954f62a4d47fe99490";
        hash = "sha256-2vRo6gnnHMsyAWea7N8MrWWztzMDPNaYhNMS7X4wOpY=";
      };
    };
  };
}
