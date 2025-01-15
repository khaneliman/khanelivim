{
  config,
  lib,
  pkgs,
  ...
}:
{
  extraConfigLuaPre = lib.mkIf config.plugins.snacks.enable (
    lib.mkOrder 1 (
      lib.optionalString config.plugins.snacks.settings.profiler.enabled # Lua
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
    )
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
