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

  keymaps = lib.mkIf config.plugins.mini-git.enable [
    # TODO: relocate
    # {
    #   mode = "n";
    #   key = "<leader>gD";
    #   action = "<CMD>lua MiniGit.show_diff_source()<CR>";
    #   options = {
    #     desc = "Show diff source";
    #   };
    # }
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
  ];
}
