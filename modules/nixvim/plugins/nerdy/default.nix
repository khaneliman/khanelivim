{
  config,
  lib,
  ...
}:
{
  plugins.nerdy = {
    enable =
      !config.plugins.snacks.enable
      || (config.plugins.snacks.enable && !lib.hasAttr "picker" config.plugins.snacks.settings);
    enableTelescope = config.plugins.telescope.enable;
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
