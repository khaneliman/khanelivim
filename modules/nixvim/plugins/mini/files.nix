{ config, lib, ... }:
{
  keymaps = lib.mkIf (config.khanelivim.editor.fileManager == "mini-files") [
    {
      mode = "n";
      key = "<leader>E";
      action.__raw = "MiniFiles.open()";
      options = {
        desc = "Mini Files";
      };
    }
    {
      mode = "n";
      key = "<leader>eF";
      action.__raw = "function() MiniFiles.open(vim.api.nvim_buf_get_name(0)) end";
      options = {
        desc = "Mini Files (current file)";
      };
    }
  ];

  plugins.mini-files = lib.mkIf (config.khanelivim.editor.fileManager == "mini-files") {
    enable = true;
    settings = {
      windows.preview = true;
    };
  };

  autoCmd = lib.mkIf config.plugins.mini-files.enable [
    {
      event = "User";
      pattern = [ "MiniFilesExplorerOpen" ];
      callback.__raw = ''
        function()
          MiniFiles.set_bookmark("c", vim.fn.stdpath("config"), { desc = "Config" })
          MiniFiles.set_bookmark("w", vim.fn.getcwd, { desc = "Working directory" })
        end
      '';
    }
  ];
}
