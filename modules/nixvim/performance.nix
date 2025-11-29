{
  config,
  lib,
  pkgs,
  ...
}:
let
  # Generate globals to disable built-in plugins
  disabledPluginGlobals = lib.listToAttrs (
    map (plugin: {
      name = "loaded_${plugin}";
      value = 1;
    }) config.khanelivim.performance.disabledPlugins
  );
in
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

  # Disable built-in plugins via globals
  globals = lib.mkIf config.khanelivim.performance.optimizeEnable disabledPluginGlobals;
}
