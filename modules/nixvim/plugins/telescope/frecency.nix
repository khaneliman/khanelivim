{
  config,
  lib,
  ...
}:
{
  plugins.telescope = lib.mkIf (config.khanelivim.picker.tool == "telescope") {
    extensions = {
      frecency = {
        enable = true;

        # TODO: migrate to mkNeovimPlugin
        # lazyLoad = {
        #   settings = {
        #     before.__raw = ''
        #       require('lz.n').trigger_load('telescope')
        #     '';
        #     cmd = "Telescope frecency";
        #     keys = [
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

  keymaps = lib.mkIf (config.khanelivim.picker.tool == "telescope") [
    {
      mode = "n";
      key = "<leader>fO";
      action = "<cmd>Telescope frecency<CR>";
      options = {
        desc = "Find Frequent Files";
      };
    }
  ];
}
