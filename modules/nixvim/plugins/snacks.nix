{
  config,
  self,
  ...
}:
{
  imports = self.lib.khanelivim.readAllFiles ./snacks;

  plugins = {
    snacks = {
      enable = true;

      settings = {
        indent.enabled = true;
        scroll.enabled = true;
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
