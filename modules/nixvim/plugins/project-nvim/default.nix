{
  config,
  lib,
  ...
}:
{
  plugins.project-nvim = {
    enable = config.khanelivim.picker.engine == "telescope";
    enableTelescope = config.khanelivim.picker.engine == "telescope";
    # package = pkgs.vimPlugins.project-nvim.overrideAttrs (_old: {
    #   patches = [
    #     (pkgs.fetchpatch {
    #       name = "get_clients";
    #       url = "https://github.com/ahmedkhalf/project.nvim/pull/183.patch";
    #       hash = "sha256-li14JdbMySzqPLdbENpJ0JJGD6c2qjjmzi2Y1giksoA=";
    #     })
    #   ];
    # });

    # NOTE: Annoying bug where you need to trigger it twice to see your projects when lazy loading.
    lazyLoad.settings = lib.mkIf (config.khanelivim.picker.engine == "telescope") {
      before.__raw =
        lib.mkIf config.plugins.lz-n.enable # Lua
          ''
            require('lz.n').trigger_load('telescope')
          '';
      keys = lib.mkIf (config.khanelivim.picker.engine == "telescope") [
        {
          __unkeyed-1 = "<leader>fp";
          __unkeyed-2 = "<cmd>Telescope projects<CR>";
          desc = "Find projects";
        }
      ];
    };
  };

  keymaps = lib.mkIf (config.khanelivim.picker.engine == "telescope" && !config.plugins.lz-n.enable) [
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
