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
      # NOTE: constant doc/tags conflicts
      # enable = true;

      standalonePlugins = with pkgs.vimPlugins; [
        "firenvim"
        "neotest"
        "nvim-treesitter"
        mini-nvim
        overseer-nvim
        vs-tasks-nvim
        "friendly-snippets" # needed for blink to access friendly-snippets
      ];
    };
  };
}
