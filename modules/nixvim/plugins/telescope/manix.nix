{
  config,
  lib,
  ...
}:
{
  plugins.telescope = lib.mkIf (config.khanelivim.picker.engine == "telescope") {
    extensions = {
      manix.enable = true;
    };
  };

  keymaps = lib.mkIf (config.khanelivim.picker.engine == "telescope") [
    {
      mode = "n";
      key = "<leader>fM";
      action = "<cmd>Telescope manix<CR>";
      options = {
        desc = "Search manix";
      };
    }
  ];
}
