_: _final: prev: {
  vimPlugins = prev.vimPlugins // {
    blink-cmp = prev.vimPlugins.blink-cmp.overrideAttrs {
      version = "0.7.3";
      src = prev.fetchFromGitHub {
        owner = "Saghen";
        repo = "blink.cmp";
        rev = "v0.7.3";
        hash = "sha256-nxiODLKgGeXzN5sqkLWU0PcsuSSB1scSzTC5qyCxLCI=";
      };
    };
  };
}
