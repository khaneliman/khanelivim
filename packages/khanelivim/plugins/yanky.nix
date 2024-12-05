{
  plugins = {
    yanky = {
      enable = true;

      lazyLoad = {
        settings = {
          keys = [
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
            }
            {
              __unkeyed-1 = "p";
              __unkeyed-2 = "<Plug>(YankyPutAfter)";
              mode = [
                "n"
                "x"
              ];
            }
            {
              __unkeyed-1 = "P";
              __unkeyed-2 = "<Plug>(YankyPutBefore)";
              mode = [
                "n"
                "x"
              ];
            }
            {
              __unkeyed-1 = "gp";
              __unkeyed-2 = "<Plug>(YankyGPutAfter)";
              mode = [
                "n"
                "x"
              ];
            }
            {
              __unkeyed-1 = "gP";
              __unkeyed-2 = "<Plug>(YankyGPutBefore)";
              mode = [
                "n"
                "x"
              ];
            }
            {
              __unkeyed-1 = "<right>y";
              __unkeyed-2 = "<Plug>(YankyCycleForward)";
            }
            {
              __unkeyed-1 = "<left>y";
              __unkeyed-2 = "<Plug>(YankyCycleBackward)";
            }
            {
              __unkeyed-1 = "<right>p";
              __unkeyed-2 = "<Plug>(YankyPutIndentAfterLinewise)";
            }
            {
              __unkeyed-1 = "<left>p";
              __unkeyed-2 = "<Plug>(YankyPutIndentBeforeLinewise)";
            }
            {
              __unkeyed-1 = "<right>P";
              __unkeyed-2 = "<Plug>(YankyPutIndentAfterLinewise)";
            }
            {
              __unkeyed-1 = "<left>P";
              __unkeyed-2 = "<Plug>(YankyPutIndentBeforeLinewise)";
            }
            {
              __unkeyed-1 = ">p";
              __unkeyed-2 = "<Plug>(YankyPutIndentAfterShiftRight)";
            }
            {
              __unkeyed-1 = "<p";
              __unkeyed-2 = "<Plug>(YankyPutIndentAfterShiftLeft)";
            }
            {
              __unkeyed-1 = ">P";
              __unkeyed-2 = "<Plug>(YankyPutIndentBeforeShiftRight)";
            }
            {
              __unkeyed-1 = "<P";
              __unkeyed-2 = "<Plug>(YankyPutIndentBeforeShiftLeft)";
            }
            {
              __unkeyed-1 = "=p";
              __unkeyed-2 = "<Plug>(YankyPutAfterFilter)";
            }
            {
              __unkeyed-1 = "=P";
              __unkeyed-2 = "<Plug>(YankyPutBeforeFilter)";
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
