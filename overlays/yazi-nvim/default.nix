_: _final: prev: {
  vimPlugins = prev.vimPlugins // {
    yazi-nvim = prev.vimPlugins.yazi-nvim.overrideAttrs {
      pname = "yazi.nvim";
      version = "2024-12-10";
      src = prev.fetchFromGitHub {
        owner = "mikavilpas";
        repo = "yazi.nvim";
        rev = "ce6b5b249cde9e4a27dfce18a6adb57c170d4325";
        sha256 = "0n4bz8iv5nxfm1gmn02jy0ixfj7lfb8rkli7l95c81h7v84wrxga";
      };
      meta.homepage = "https://github.com/mikavilpas/yazi.nvim/";
    };
  };
}
