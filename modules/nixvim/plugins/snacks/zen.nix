{
  config,
  lib,
  ...
}:
let
  zenEnabled = config.khanelivim.ui.zenMode == "snacks";
in
{
  plugins = {
    snacks = {
      settings = {
        zen.enabled = zenEnabled;
      };
    };
  };

  keymaps =
    lib.mkIf
      (
        zenEnabled
        && config.plugins.snacks.enable
        && lib.hasAttr "zen" config.plugins.snacks.settings
        && config.plugins.snacks.settings.zen.enabled
        && !(
          lib.hasAttr "toggle" config.plugins.snacks.settings && config.plugins.snacks.settings.toggle.enabled
        )
      )
      [
        {
          mode = "n";
          key = "<leader>uZ";
          action = "<cmd>lua Snacks.zen()<CR>";
          options = {
            desc = "Toggle Zen Mode";
          };
        }
      ];
}
