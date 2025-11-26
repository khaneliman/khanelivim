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
        # `PROF=1 nvim` - profiles to UIEnter (default)
        # `PROF=1 PROF_EVENT=deferred nvim` - profiles to DeferredUIEnter (lz.n lazy loads)
        # `PROF=1 PROF_EVENT=lazy nvim` - profiles to VeryLazy
        lib.mkOrder 1 # Lua
          ''
            if vim.env.PROF then
              local snacks = "${pkgs.vimPlugins.snacks-nvim}"
              vim.opt.rtp:append(snacks)

              local event = "UIEnter"
              local pattern = nil

              if vim.env.PROF_EVENT == "deferred" then
                event = "User"
                pattern = "DeferredUIEnter"
              elseif vim.env.PROF_EVENT == "lazy" then
                event = "User"
                pattern = "VeryLazy"
              end

              require("snacks.profiler").startup({
                startup = {
                  event = event,
                  pattern = pattern,
                },
              })
            end
          ''

      );

  plugins = {
    snacks = {
      settings = {
        profiler.enabled = true;
      };
    };
  };

}
