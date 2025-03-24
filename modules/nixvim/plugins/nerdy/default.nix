{
  config,
  ...
}:
{
  plugins.nerdy = {
    enable = true;
    enableTelescope = config.plugins.telescope.enable;
  };

  keymaps = [
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
