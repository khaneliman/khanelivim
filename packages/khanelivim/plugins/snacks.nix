{ config, ... }:
{
  plugins = {
    snacks = {
      enable = true;

      settings = {
        bigfile = {
          enabled = true;
        };
        statuscolumn = {
          enabled = true;

          folds = {
            open = true;
            git_hl = config.plugins.gitsigns.enable;
          };
        };
      };
    };
  };
}
