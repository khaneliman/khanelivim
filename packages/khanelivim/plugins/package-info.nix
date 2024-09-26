{ config, lib, ... }:
{
  plugins.package-info = {
    enable = true;
    enableTelescope = true;
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
