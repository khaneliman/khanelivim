{ config, lib, ... }:
{
  plugins = {
    yanky = {
      enable = true;

      lazyLoad = {
        settings = {
          keys = lib.mkIf config.plugins.lz-n.enable [
            {
              __unkeyed-1 = "<leader>fy";
              __unkeyed-2 = "<cmd>Telescope yank_history<cr>";
              desc = "Paste from yanky";
            }
            {
              __unkeyed-1 = "y";
              __unkeyed-2 = "<Plug>(YankyYank)";
              mode = [
                "n"
                "x"
              ];
              desc = "Yank text";
            }
            {
              __unkeyed-1 = "p";
              __unkeyed-2 = "<Plug>(YankyPutAfter)";
              mode = [
                "n"
                "x"
              ];
              desc = "Put yanked text after cursor";
            }
            {
              __unkeyed-1 = "P";
              __unkeyed-2 = "<Plug>(YankyPutBefore)";
              mode = [
                "n"
                "x"
              ];
              desc = "Put yanked text before cursor";
            }
            {
              __unkeyed-1 = "gp";
              __unkeyed-2 = "<Plug>(YankyGPutAfter)";
              mode = [
                "n"
                "x"
              ];
              desc = "Put yanked text after selection";
            }
            {
              __unkeyed-1 = "gP";
              __unkeyed-2 = "<Plug>(YankyGPutBefore)";
              mode = [
                "n"
                "x"
              ];
              desc = "Put yanked text before selection";
            }
            {
              __unkeyed-1 = "<c-p>";
              __unkeyed-2 = "<Plug>(YankyPreviousEntry)";
              desc = "Select previous entry through yank history";
            }
            {
              __unkeyed-1 = "<c-n>";
              __unkeyed-2 = "<Plug>(YankyNextEntry)";
              desc = "Select next entry through yank history";
            }
            {
              __unkeyed-1 = "]p";
              __unkeyed-2 = "<Plug>(YankyPutIndentAfterLinewise)";
              desc = "Put indented after cursor (linewise)";
            }
            {
              __unkeyed-1 = "[p";
              __unkeyed-2 = "<Plug>(YankyPutIndentBeforeLinewise)";
              desc = "Put indented before cursor (linewise)";
            }
            {
              __unkeyed-1 = "]P";
              __unkeyed-2 = "<Plug>(YankyPutIndentAfterLinewise)";
              desc = "Put indented after cursor (linewise)";
            }
            {
              __unkeyed-1 = "[P";
              __unkeyed-2 = "<Plug>(YankyPutIndentBeforeLinewise)";
              desc = "Put indented before cursor (linewise)";
            }
            {
              __unkeyed-1 = ">p";
              __unkeyed-2 = "<Plug>(YankyPutIndentAfterShiftRight)";
              desc = "Put and indent right";
            }
            {
              __unkeyed-1 = "<p";
              __unkeyed-2 = "<Plug>(YankyPutIndentAfterShiftLeft)";
              desc = "Put and indent left";
            }
            {
              __unkeyed-1 = ">P";
              __unkeyed-2 = "<Plug>(YankyPutIndentBeforeShiftRight)";
              desc = "Put before and indent right";
            }
            {
              __unkeyed-1 = "<P";
              __unkeyed-2 = "<Plug>(YankyPutIndentBeforeShiftLeft)";
              desc = "Put before and indent left";
            }
            {
              __unkeyed-1 = "=p";
              __unkeyed-2 = "<Plug>(YankyPutAfterFilter)";
              desc = "Put after applying a filter";
            }
            {
              __unkeyed-1 = "=P";
              __unkeyed-2 = "<Plug>(YankyPutBeforeFilter)";
              desc = "Put before applying a filter";
            }
          ];
        };
      };

      settings = {
        ring = {
          history_length = 100;
          storage = "sqlite";
          storage_path.__raw = "vim.fn.stdpath('data') .. '/databases/yanky.db'";
          sync_with_numbered_registers = true;
          cancel_event = "update";
          ignore_registers = [ "_" ];
          update_register_on_cycle = false;
        };
      };
    };
  };
}
