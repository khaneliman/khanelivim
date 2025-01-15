{
  config,
  lib,
  ...
}:
{
  plugins = {
    snacks = {
      enable = true;

      settings = {
        zen.enabled = true;
      };
    };
  };

  keymaps = lib.mkIf (config.plugins.snacks.enable && config.plugins.snacks.settings.zen.enabled) [
    {
      mode = "n";
      key = "<leader>uZ";
      action = "<cmd>lua Snacks.zen()<CR>";
      options = {
        desc = "Zen Toggle";
      };
    }
  ];
}
