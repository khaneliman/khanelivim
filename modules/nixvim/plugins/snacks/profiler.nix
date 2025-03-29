{
  config,
  lib,
  pkgs,
  ...
}:
{
  extraConfigLuaPre =
    lib.mkIf
      (
        config.plugins.snacks.enable
        && lib.hasAttr "profiler" config.plugins.snacks.settings
        && config.plugins.snacks.settings.profiler.enabled
      )
      (
        # NOTE: Allows profiling
        # `PROF=1 nvim`
        lib.mkOrder 1 # Lua
          ''
            if vim.env.PROF then
              local snacks = "${pkgs.vimPlugins.snacks-nvim}"
              vim.opt.rtp:append(snacks)
              require("snacks.profiler").startup({
                startup = {
                  -- event = "VimEnter", -- stop profiler on this event. Defaults to `VimEnter`
                  event = "UIEnter",
                  -- event = "VeryLazy",
                },
              })
            end
          ''

      );

  plugins = {
    snacks = {
      enable = true;

      settings = {
        profiler.enabled = true;
      };
    };
  };

}
