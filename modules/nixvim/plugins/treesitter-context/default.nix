{
  config,
  lib,
  ...
}:
{
  plugins = {
    treesitter-context = {
      # nvim-treesitter-context documentation
      # See: https://github.com/nvim-treesitter/nvim-treesitter-context
      inherit (config.plugins.treesitter) enable;
      lazyLoad.settings.event = [
        "BufReadPost"
        "BufNewFile"
      ];
      settings = {
        max_lines = 4;
        min_window_height = 40;
        multiwindow = true;
        separator = "-";
      };
    };
  };

  keymaps = lib.mkIf config.plugins.treesitter-context.enable [
    {
      mode = "n";
      key = "<leader>ut";
      action = "<cmd>TSContextToggle<cr>";
      options = {
        desc = "Treesitter Context toggle";
      };
    }
  ];
}
