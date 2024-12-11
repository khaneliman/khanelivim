{ config, lib, ... }:
{
  plugins.project-nvim = {
    enable = true;
    enableTelescope = true;

    lazyLoad.settings.cmd = "Telescope projects";
  };

  keymaps = lib.mkIf (config.plugins.telescope.enable && config.plugins.project-nvim.enable) [
    {
      mode = "n";
      key = "<leader>fp";
      action = "<cmd>Telescope projects<CR>";
      options = {
        desc = "Find projects";
      };
    }
  ];
}
