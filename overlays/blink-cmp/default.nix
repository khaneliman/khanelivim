_: _final: prev: {
  vimPlugins = prev.vimPlugins // {
    blink-cmp = prev.vimPlugins.blink-cmp.overrideAttrs {
      version = "0.7.4";
      src = prev.fetchFromGitHub {
        owner = "Saghen";
        repo = "blink.cmp";
        rev = "v0.7.4";
        hash = "sha256-xFTCftqz47/6m2h/dOmMI2T5aEvOvs7ixs46vKBAdDY=";
      };
    };
  };
}
