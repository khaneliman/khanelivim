{
  config,
  lib,
  pkgs,
  ...
}:
{
  plugins.project-nvim = {
    enable =
      !config.plugins.snacks.enable
      || (config.plugins.snacks.enable && !lib.hasAttr "picker" config.plugins.snacks.settings);
    enableTelescope = config.plugins.telescope.enable;
    package = pkgs.vimPlugins.project-nvim.overrideAttrs (_old: {
      patches = [
        (pkgs.fetchpatch {
          name = "get_clients";
          url = "https://github.com/ahmedkhalf/project.nvim/pull/183.patch";
          hash = "sha256-li14JdbMySzqPLdbENpJ0JJGD6c2qjjmzi2Y1giksoA=";
        })
      ];
    });

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
