{
  config,
  lib,
  ...
}:
{
  plugins = {
    snacks = {
      settings = {
        words.enabled = config.khanelivim.ui.referenceHighlighting == "snacks-words";
      };
    };
  };

  keymaps =
    lib.mkIf
      (
        config.plugins.snacks.enable
        && lib.hasAttr "words" config.plugins.snacks.settings
        && config.plugins.snacks.settings.words.enabled
      )
      [
        {
          mode = "n";
          key = "]]";
          action = "<cmd>lua Snacks.words.jump(vim.v.count1)<CR>";
          options = {
            desc = "Next Reference";
          };
        }
        {
          mode = "n";
          key = "[[";
          action = "<cmd>lua Snacks.words.jump(-vim.v.count1)<CR>";
          options = {
            desc = "Previous Reference";
          };
        }
      ];
}
