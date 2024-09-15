{
  plugins.precognition.enable = true;

  keymaps = [
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

  # TODO: set when module is available
  # plugins.which-key.settings.spec = lib.optionals config.plugins.hardtime.enable [
  #   {
  #     __unkeyed = "<leader>H";
  #     mode = "n";
  #     desc = "Hardtime";
  #     icon = "󰖵";
  #   }
  # ];
}
