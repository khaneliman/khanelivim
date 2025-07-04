{ lib, config, ... }:
{
  extraConfigLuaPre =
    lib.mkIf (config.plugins.mini.enable && lib.hasAttr "bufdelete" config.plugins.mini.modules) # Lua
      ''
        -- Disable built-in diagnostic keymaps that conflict with <C-W> closing a buffer
        vim.keymap.del('n', '<C-W>d')
        vim.keymap.del('n', '<C-W><C-D>')
      '';

  plugins = {
    mini = {
      enable = true;

      modules = {
        # Only enable if we arent using snacks bufdelete
        bufremove = lib.mkIf (
          !config.plugins.snacks.enable
          || (
            config.plugins.snacks.enable
            && (
              !lib.hasAttr "bufdelete" config.plugins.snacks.settings
              || !config.plugins.snacks.settings.bufdelete.enabled
            )
          )
        ) { };
      };
    };
  };

  keymaps =
    lib.mkIf (config.plugins.mini.enable && lib.hasAttr "bufremove" config.plugins.mini.modules)
      [
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
                 return vim.api.nvim_buf_get_option(bufnr, "buflisted")
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
