{ config, lib, ... }:
{
  plugins.rest.enable = config.khanelivim.editor.httpClient == "rest";

  # NOTE: Works with files with .http file extension / http filetype
  # More example: https://github.com/rest-nvim/rest.nvim/tree/main/spec/examples
  # File shape:
  # Method Request-URI HTTP-Version
  # Header-field: Header-value
  #
  # Request-Body

  keymaps = lib.mkIf config.plugins.rest.enable [
    # Core REST request functionality
    {
      mode = "n";
      key = "<leader>hr";
      action = "<cmd>Rest run<cr>";
      options = {
        desc = "Run HTTP request under cursor";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>hR";
      action = "<cmd>Rest last<cr>";
      options = {
        desc = "Replay last HTTP request";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>ht";
      action = "<cmd>Rest open<cr>";
      options = {
        desc = "Toggle view (open/close result)";
        silent = true;
      };
    }

    # Environment management
    {
      mode = "n";
      key = "<leader>hes";
      action = "<cmd>Rest env select<cr>";
      options = {
        desc = "Set environment";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>hei";
      action = "<cmd>Rest env show<cr>";
      options = {
        desc = "Show environment";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>hc";
      action = "<cmd>Rest cookies<cr>";
      options = {
        desc = "Edit cookies file";
        silent = true;
      };
    }

    # Utility functions
    {
      mode = "n";
      key = "<leader>hL";
      action = "<cmd>Rest logs<cr>";
      options = {
        desc = "Edit logs file";
        silent = true;
      };
    }

    # Quick access for .http files
    {
      mode = "n";
      key = "<CR>";
      action = "<cmd>Rest run<cr>";
      options = {
        desc = "Run HTTP request under cursor";
        silent = true;
        buffer = true;
      };
    }
  ];

  # Auto commands for .http files
  autoGroups = {
    rest_group = { };
  };

  autoCmd = lib.mkIf config.plugins.rest.enable [
    {
      event = [ "FileType" ];
      pattern = [ "http" ];
      group = "rest_group";
      callback.__raw = ''
        function()
          vim.keymap.set("n", "<CR>", "<cmd>Rest run<cr>", { buffer = true, desc = "Run HTTP request" })
          vim.keymap.set("n", "<leader>ht", "<cmd>Rest open<cr>", { buffer = true, desc = "Toggle view" })
        end
      '';
    }
  ];
}
