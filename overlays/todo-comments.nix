_: _final: prev: {
  vimPlugins = prev.vimPlugins // {
    todo-comments-nvim = prev.vimPlugins.todo-comments-nvim.overrideAttrs {
      version = "2025-01-14";
      src = prev.fetchFromGitHub {
        owner = "folke";
        repo = "todo-comments.nvim";
        rev = "304a8d204ee787d2544d8bc23cd38d2f929e7cc5";
        sha256 = "0hrmiaxjp11200nds3y33brj8gpbn5ykd78jfy1jiash3d44xpva";
      };
    };
  };
}
