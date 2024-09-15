{ config, lib, ... }:
{
  plugins.project-nvim = {
    enable = true;
    enableTelescope = true;
  };

  keymaps = lib.mkIf config.plugins.telescope.enable [
    {
      mode = "n";
      key = "<leader>fp";
      action = ":Telescope projects<CR>";
      options = {
        desc = "Find projects";
        silent = true;
      };
    }
  ];
}
