{ config, lib, ... }:
let
  isEnabled = lib.elem "markdown-preview" config.khanelivim.text.markdownRendering;
in
{
  plugins.markdown-preview = {
    enable = isEnabled;
    # Put plugin in opt/ for lazy loading
    autoLoad = false;

    settings = {
      auto_close = 0;
      theme = "dark";
    };
  };

  # Configure lz-n to load on markdown filetype
  plugins.lz-n.plugins = lib.mkIf isEnabled [
    {
      __unkeyed-1 = "markdown-preview.nvim";
      ft = "markdown";
      cmd = [
        "MarkdownPreview"
        "MarkdownPreviewToggle"
        "MarkdownPreviewStop"
      ];
      keys = [
        {
          __unkeyed-1 = "<leader>pm";
          __unkeyed-2 = "<cmd>MarkdownPreview<cr>";
          desc = "Markdown Preview";
        }
      ];
    }
  ];
}
