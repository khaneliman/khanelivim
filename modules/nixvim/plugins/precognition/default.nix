{ lib, config, ... }:
{
  plugins.precognition = {
    # precognition.nvim documentation
    # See: https://github.com/tris203/precognition.nvim
    enable = true;

    lazyLoad.settings.cmd = "Precognition";

    settings = {
      startVisible = false;
    };
  };

  keymaps = lib.optionals config.plugins.precognition.enable [
    {
      mode = "n";
      key = "<leader>vp";
      action.__raw = ''
        function()
          local toggled = vim.cmd("Precognition toggle")
          if toggled then
              vim.notify("Precognition on")
          else
              vim.notify("Precognition off")
          end
        end
      '';

      options = {
        desc = "Precognition Toggle";
        silent = true;
      };
    }
  ];
}
