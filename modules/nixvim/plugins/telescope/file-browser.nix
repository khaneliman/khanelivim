{
  config,
  lib,
  ...
}:
{
  plugins.telescope = {
    extensions = {
      file-browser = {
        enable =
          !config.plugins.snacks.enable
          || (config.plugins.snacks.enable && !lib.hasAttr "picker" config.plugins.snacks.settings);
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
