{ config, lib, ... }:
{
  plugins.project-nvim = {
    enable = true;
    enableTelescope = config.plugins.telescope.enable;

    # NOTE: Annoying bug where you need to trigger it twice to see your projects when lazy loading.
    lazyLoad.settings = lib.mkIf config.plugins.telescope.enable {
      before.__raw =
        lib.mkIf config.plugins.lz-n.enable # Lua
          ''
            require('lz.n').trigger_load('telescope')
          '';
      keys =
        lib.mkIf
          (
            !config.plugins.snacks.enable
            || (config.plugins.snacks.enable && !lib.hasAttr "picker" config.plugins.snacks.settings)
          )
          [
            {
              __unkeyed-1 = "<leader>fp";
              __unkeyed-2 = "<cmd>Telescope projects<CR>";
              desc = "Find projects";
            }
          ];
    };
  };

  keymaps =
    lib.mkIf
      (
        config.plugins.telescope.enable
        && config.plugins.project-nvim.enable
        && !config.plugins.lz-n.enable
        && (
          !config.plugins.snacks.enable
          || (config.plugins.snacks.enable && !lib.hasAttr "picker" config.plugins.snacks.settings)
        )
      )
      [
        {
          mode = "n";
          key = "<leader>fp";
          action = "<cmd>Telescope projects<CR>";
          options = {
            desc = "Find projects";
          };
        }
      ];
}
