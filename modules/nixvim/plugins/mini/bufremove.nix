{ lib, config, ... }:
let
  bufremoveEnabled = config.khanelivim.ui.bufferDelete == "mini-bufremove";
in
{
  extraConfigLuaPre = lib.mkIf bufremoveEnabled ''
    -- Disable built-in diagnostic keymaps that conflict with <C-W> closing a buffer
    vim.keymap.del('n', '<C-W>d')
    vim.keymap.del('n', '<C-W><C-D>')
  '';

  plugins = {
    mini-bufremove.enable = config.khanelivim.ui.bufferDelete == "mini-bufremove";
  };

  keymaps = lib.mkIf bufremoveEnabled [
    {
      mode = "n";
      key = "<C-w>";
      action.__raw = ''require("mini.bufremove").delete'';
      options = {
        desc = "Close buffer";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>bc";
      action.__raw = ''
        function ()
          local current = vim.api.nvim_get_current_buf()

          local get_listed_bufs = function()
            return vim.tbl_filter(function(bufnr)
             return vim.bo[bufnr].buflisted
            end, vim.api.nvim_list_bufs())
          end

          for _, bufnr in ipairs(get_listed_bufs()) do
            if bufnr ~= current
            then require("mini.bufremove").delete(bufnr)
            end
          end
        end
      '';
      options = {
        desc = "Close all buffers but current";
      };
    }
  ];
}
