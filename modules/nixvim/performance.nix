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
      enable = true;
      standalonePlugins = with pkgs.vimPlugins; [
        "firenvim"
        "neotest"
        "nvim-treesitter"
        mini-nvim
        overseer-nvim
        self.packages.${system}.tree-sitter-norg-meta
        self.packages.${system}.tree-sitter-nu
        vs-tasks-nvim
      ];
    };
  };
}
