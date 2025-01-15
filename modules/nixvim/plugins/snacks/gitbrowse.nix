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
        gitbrowse.enabled = true;
      };
    };
  };

  keymaps =
    lib.mkIf
      (
        config.plugins.snacks.enable
        && lib.hasAttr "gitbrowse" config.plugins.snacks.settings
        && config.plugins.snacks.settings.gitbrowse.enabled
      )
      [
        {
          mode = "n";
          key = "<leader>go";
          action = "<cmd>lua Snacks.gitbrowse()<CR>";
          options = {
            desc = "Open file in browser";
          };
        }
      ];
}
