{
  config,
  lib,
  ...
}:
{
  plugins.telescope = {
    extensions = {
      manix.enable = true;
    };
  };

  keymaps = lib.mkIf config.plugins.telescope.enable [
    (lib.mkIf config.plugins.telescope.extensions.manix.enable {
      mode = "n";
      key = "<leader>fM";
      action = "<cmd>Telescope manix<CR>";
      options = {
        desc = "Search manix";
      };
    })
  ];
}
