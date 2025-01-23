{ config, lib, ... }:
{
  plugins.markdown-preview = {
    enable = true;

    # TODO: migrate to mkNeovimPlugin
    # lazyLoad.settings.cmd = "MarkdownPreview";

    settings = {
      auto_close = 0;
      theme = "dark";
    };
  };

  keymaps = lib.mkIf config.plugins.markdown-preview.enable [
    {
      mode = "n";
      key = "<leader>pm";
      action = "<cmd>MarkdownPreview<cr>";
      options = {
        desc = "Markdown Preview";
      };
    }
  ];
}
