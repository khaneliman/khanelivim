{
  config,
  lib,
  pkgs,
  ...
}:
{
  performance = lib.mkIf config.khanelivim.performance.optimizeEnable {
    byteCompileLua = {
      enable = true;
      configs = true;
      luaLib = true;
      nvimRuntime = true;
      plugins = true;
    };
    combinePlugins = {
      # FIXME: doc tags conflicts again...
      enable = false;

      standalonePlugins = with pkgs.vimPlugins; [
        "firenvim"
        "neotest"
        "nvim-treesitter"
        mini-nvim
        overseer-nvim
        vs-tasks-nvim
      ];
    };
  };
}
