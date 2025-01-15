{
  config,
  lib,
  ...
}:
{
  plugins.telescope = {
    extensions = {
      file-browser = {
        enable = true;
        settings = {
          hidden = true;
        };
      };
    };
  };

  keymaps = lib.mkIf config.plugins.telescope.enable [
    (lib.mkIf config.plugins.telescope.extensions.file-browser.enable {
      mode = "n";
      key = "<leader>fe";
      action = "<cmd>Telescope file_browser<CR>";
      options = {
        desc = "File Explorer";
      };
    })
  ];
}
