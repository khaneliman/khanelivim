{
  config,
  lib,
  ...
}:
{
  plugins.telescope = lib.mkIf (config.khanelivim.picker.engine == "telescope") {
    extensions = {
      file-browser = {
        enable = true;
        settings = {
          hidden = true;
        };
      };
    };
  };

  keymaps = lib.mkIf (config.khanelivim.picker.engine == "telescope") [
    {
      mode = "n";
      key = "<leader>fe";
      action = "<cmd>Telescope file_browser<CR>";
      options = {
        desc = "File Explorer";
      };
    }
  ];
}
