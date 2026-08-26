{
  config,
  lib,
  ...
}:
{
  plugins.claude-fzf-history = {
    # claude-fzf-history needs fzf-lua, which loads only with the fzf picker.
    enable = lib.mkDefault (config.plugins.claudecode.enable && config.plugins.fzf-lua.enable);

    settings = {
      preview = {
        position = "right:60%";
        wrap = true;
        syntax_highlighting = {
          theme = "Catppuccin Macchiato";
          language = "markdown";
          show_line_numbers = false;
        };
      };

      logging.level = "WARN";
    };

    lazyLoad = lib.mkIf config.plugins.lz-n.enable {
      settings.cmd = [ "ClaudeHistory" ];
    };
  };

  keymaps = lib.mkIf config.plugins.claude-fzf-history.enable [
    {
      mode = "n";
      key = "<leader>ach";
      action = "<cmd>ClaudeHistory<CR>";
      options = {
        desc = "Claude History";
        silent = true;
      };
    }
  ];
}
