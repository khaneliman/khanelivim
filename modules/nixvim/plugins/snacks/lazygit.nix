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
        lazygit.enabled = true;
      };
    };
  };

  keymaps =
    lib.mkIf
      (
        config.plugins.snacks.enable
        && lib.hasAttr "lazygit" config.plugins.snacks.settings
        && config.plugins.snacks.settings.lazygit.enabled
      )
      [
        {
          mode = "n";
          key = "<leader>tg";
          action = "<cmd>lua Snacks.lazygit()<CR>";
          options = {
            desc = "Open lazygit";
          };
        }
        {
          mode = "n";
          key = "<leader>gg";
          action = "<cmd>lua Snacks.lazygit()<CR>";
          options = {
            desc = "Open lazygit";
          };
        }
      ];
}
