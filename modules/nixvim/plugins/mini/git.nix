{ lib, config, ... }:
{
  plugins.mini-git.enable = true;

  # Disable mini.git globally at startup to prevent errors with plugin buffers.
  globals.minigit_disable = true;

  # Enable mini.git only for file-based buffers.
  autoCmd = [
    {
      event = "BufAdd";
      pattern = "*";
      callback.__raw = ''
        function()
          local buf = vim.api.nvim_get_current_buf()
          if vim.bo[buf].buftype == "" then
            vim.b[buf].minigit_disable = false
          end
        end
      '';
    }
  ];

  plugins.which-key.settings.spec = lib.mkIf config.plugins.mini-git.enable [
    {
      __unkeyed-1 = "<leader>g";
      group = "Git";
      icon = "";
    }
  ];

  keymaps = lib.mkIf config.plugins.mini-git.enable [
    {
      mode = "";
      key = "<leader>gH";
      action = "<CMD>lua MiniGit.show_range_history()<CR>";
      options = {
        desc = "Show range history";
      };
    }
    {
      mode = "n";
      key = "<leader>g.";
      action = "<CMD>lua MiniGit.show_at_cursor()<CR>";
      options = {
        desc = "Show git context";
      };
    }
    {
      mode = "n";
      key = "<leader>gB";
      action.__raw = ''
        function()
          local summary = MiniGit.show_at_cursor()
          if summary then
            vim.notify(summary, vim.log.levels.INFO)
          end
        end
      '';
      options = {
        desc = "Show git blame at cursor";
      };
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>gh";
      action = "<CMD>lua MiniGit.show_range_history()<CR>";
      options = {
        desc = "Show git history (range)";
      };
    }
    {
      mode = "n";
      key = "<leader>gC";
      action.__raw = ''
        function()
          require('mini.git').show_at_cursor()
        end
      '';
      options = {
        desc = "Show commit info at cursor";
      };
    }
  ];
}
