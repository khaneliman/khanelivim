{ lib, config, ... }:
{
  plugins.precognition = {
    enable = true;
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
          if require("precognition").toggle() then
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
