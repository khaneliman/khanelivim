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

    plugins.which-key.settings.spec = lib.mkIf config.plugins.unified.enable [
      {
        __unkeyed = "<leader>gd";
        group = "Diff";
        icon = " ";
      }
    ];

    keymaps = lib.mkIf config.plugins.unified.enable (
      [
        {
          mode = "n";
          key = "]h";
          action = "<cmd>lua require('unified.navigation').next_hunk()<CR>";
          options = {
            desc = "Next hunk (unified)";
          };
        }
        {
          mode = "n";
          key = "[h";
          action = "<cmd>lua require('unified.navigation').previous_hunk()<CR>";
          options = {
            desc = "Previous hunk (unified)";
          };
        }
        # Unified diff commands under <leader>gd namespace
        {
          mode = "n";
          key = "<leader>gdu";
          action = "<cmd>Unified<CR>";
          options = {
            desc = "Unified Diff";
          };
        }
        {
          mode = "n";
          key = "<leader>gdU";
          action = "<cmd>Unified HEAD~1<CR>";
          options = {
            desc = "Unified Diff (-1)";
          };
        }
        {
          mode = "n";
          key = "<leader>gdr";
          action = "<cmd>Unified reset<CR>";
          options = {
            desc = "Reset Unified Diff";
          };
        }
      ]
      ++ lib.optionals (config.khanelivim.editor.diffViewer == "unified") [
        # Primary diff shortcut when unified is the chosen diff viewer
        {
          mode = "n";
          key = "<leader>gD";
          action.__raw = ''
            function()
              if vim.g.unified_diff_enabled then
                vim.cmd('Unified reset')
                vim.g.unified_diff_enabled = false
              else
                vim.cmd('Unified')
                vim.g.unified_diff_enabled = true
              end
            end
          '';
          options = {
            desc = "Toggle Diff (Primary)";
          };
        }
      ]
    );
  };
}
