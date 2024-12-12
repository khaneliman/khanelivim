{ config, lib, ... }:
{
  plugins.package-info = {
    enable = true;
    enableTelescope = true;

    lazyLoad.settings = {
      ft = "json";
      cmd = "Telescope package_info";
    };
  };

  keymaps = lib.mkIf (config.plugins.telescope.enable && config.plugins.package-info.enable) [
    {
      mode = "n";
      key = "<leader>fP";
      action = "<cmd>Telescope package_info<CR>";
      options = {
        desc = "Find package info";
      };
    }
  ];
}
