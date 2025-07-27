{
  pkgs,
  self,
  system,
  ...
}:
{
  performance = {
    byteCompileLua = {
      enable = true;
      configs = true;
      luaLib = true;
      nvimRuntime = true;
      plugins = true;
    };
    combinePlugins = {
      # FIXME: every plugin clashing on `doc/tags`
      # enable = true;

      standalonePlugins = with pkgs.vimPlugins; [
        "firenvim"
        "neotest"
        "nvim-treesitter"
        mini-nvim
        overseer-nvim
        self.packages.${system}.tree-sitter-norg-meta
        vs-tasks-nvim
      ];
    };
  };
}
