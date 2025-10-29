{
  config,
  lib,
  ...
}:
{
  plugins.nerdy = {
    enable = config.khanelivim.picker.tool == "telescope";
    enableTelescope = config.khanelivim.picker.tool == "telescope";
  };

  keymaps = lib.mkIf config.plugins.nerdy.enable [
    {
      mode = "n";
      key = "<leader>f,";
      action = "<CMD>Nerdy<CR>";
      options = {
        desc = "Find Nerd Icons";
      };
    }
  ];
}
