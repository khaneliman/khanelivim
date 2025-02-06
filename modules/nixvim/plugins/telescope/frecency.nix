{
  config,
  lib,
  ...
}:
{
  plugins.telescope = {
    extensions = {
      frecency = {
        enable =
          !config.plugins.snacks.enable
          || (config.plugins.snacks.enable && !lib.hasAttr "picker" config.plugins.snacks.settings);

        # TODO: migrate to mkNeovimPlugin
        # lazyLoad = {
        #   settings = {
        #     before.__raw = lib.mkIf config.plugins.telescope.enable ''
        #       require('lz.n').trigger_load('telescope')
        #     '';
        #     cmd = "Telescope frecency";
        #     keys = lib.mkIf config.plugins.telescope.enable [
        #       {
        #         __unkeyed-1 = "<leader>fO";
        #         __unkeyed-2 = "<cmd>Telescope frecency<CR>";
        #         desc = "Find frequent files";
        #       }
        #     ];
        #   };
        # };

        settings = {
          auto_validate = false;
        };
      };
    };
  };

  keymaps = lib.mkIf config.plugins.telescope.enable [
    (lib.mkIf config.plugins.telescope.extensions.frecency.enable {
      mode = "n";
      key = "<leader>fO";
      action = "<cmd>Telescope frecency<CR>";
      options = {
        desc = "Find Frequent Files";
      };
    })
  ];
}
