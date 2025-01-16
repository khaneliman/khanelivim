_: _final: prev: {
  vimPlugins = prev.vimPlugins // {
    todo-comments-nvim = prev.vimPlugins.todo-comments-nvim.overrideAttrs (_oldAttrs: {
      version = "2025-01-16";
      src = prev.fetchFromGitHub {
        owner = "folke";
        repo = "todo-comments.nvim";
        rev = "304a8d204ee787d2544d8bc23cd38d2f929e7cc5";
        sha256 = "at9OSBtQqyiDdxKdNn2x6z4k8xrDD90sACKEK7uKNUM=";
      };
    });
  };
}
