_: _final: prev: {
  vimPlugins = prev.vimPlugins // {
    yazi-nvim = prev.vimPlugins.yazi-nvim.overrideAttrs {
      pname = "yazi.nvim";
      version = "2024-12-08";
      src = prev.fetchFromGitHub {
        owner = "mikavilpas";
        repo = "yazi.nvim";
        rev = "ce6b5b249cde9e4a27dfce18a6adb57c170d4325";
        hash = "sha256-6vXMCdoHBsRKoifSmdFy9EjXI/BSAFtfqK7bsiP6i1g=";
      };
      meta.homepage = "https://github.com/mikavilpas/yazi.nvim/";
    };
  };
}
