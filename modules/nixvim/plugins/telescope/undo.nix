{
  config,
  lib,
  ...
}:
{
  plugins.telescope = {
    extensions = {
      undo = {
        enable = true;
        settings = {
          side_by_side = true;
          layout_strategy = "vertical";
          layout_config = {
            preview_height = 0.8;
          };
        };
      };
    };
  };

  keymaps = lib.mkIf config.plugins.telescope.enable [
    (lib.mkIf config.plugins.telescope.extensions.undo.enable {
      mode = "n";
      key = "<leader>fu";
      action = "<cmd>Telescope undo<CR>";
      options = {
        desc = "List undo history";
      };
    })
  ];
}
