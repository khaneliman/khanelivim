{
  config,
  lib,
  ...
}:
{
  config = {
    plugins.unified = {
      enable = config.khanelivim.editor.diffViewer == "unified";
    };

    # TODO: implement after next plugin update
    # vim.keymap.set('n', ']h', function() require('unified.navigation').next_hunk() end)
    # vim.keymap.set('n', '[h', function() require('unified.navigation').previous_hunk() end)
    keymaps = lib.mkIf config.plugins.unified.enable [
      {
        mode = "n";
        key = "<leader>gd";
        action = "<cmd>Unified<CR>";
        options = {
          desc = "Open Unified Diff";
        };
      }
      {
        mode = "n";
        key = "<leader>gD";
        action = "<cmd>Unified HEAD~1<CR>";
        options = {
          desc = "Open Unified Diff (-1)";
        };
      }
      {
        mode = "n";
        key = "<leader>ugo";
        action = "<cmd>Unified<CR>";
        options = {
          desc = "Open Unified Diff";
        };
      }
      {
        mode = "n";
        key = "<leader>ugc";
        action = "<cmd>Unified reset<CR>";
        options = {
          desc = "Close Unified Diff";
        };
      }
    ];
  };
}
