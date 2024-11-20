{ config, ... }:
{
  plugins = {
    snacks = {
      enable = true;

      settings = {
        bigfile = {
          enabled = true;
          size = 1024 * 1024; # 1MB
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
