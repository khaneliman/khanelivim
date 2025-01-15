{
  config,
  lib,
  ...
}:
{
  plugins.telescope = {
    extensions = {
      frecency = {
        # FIXME: super slow loading
        # enable = true;
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
