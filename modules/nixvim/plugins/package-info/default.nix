{ config, lib, ... }:
{
  plugins.package-info = {
    enable = true;
    enableTelescope = config.plugins.telescope.enable;

    lazyLoad.settings = {
      event = [ "BufRead package.json" ];
    };

    settings = {
      hide_up_to_date = true;
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
