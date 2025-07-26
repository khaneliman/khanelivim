{ config, lib, ... }:
let
  yankyKeymaps = [
    {
      mode = [
        "n"
        "x"
      ];
      key = "y";
      action = "<Plug>(YankyYank)";
      options.desc = "Yank text";
    }
    {
      mode = [
        "n"
        "x"
      ];
      key = "p";
      action = "<Plug>(YankyPutAfter)";
      options.desc = "Put yanked text after cursor";
    }
    {
      mode = [
        "n"
        "x"
      ];
      key = "P";
      action = "<Plug>(YankyPutBefore)";
      options.desc = "Put yanked text before cursor";
    }
    {
      mode = [
        "n"
        "x"
      ];
      key = "gp";
      action = "<Plug>(YankyGPutAfter)";
      options.desc = "Put yanked text after selection";
    }
    {
      mode = [
        "n"
        "x"
      ];
      key = "gP";
      action = "<Plug>(YankyGPutBefore)";
      options.desc = "Put yanked text before selection";
    }
    {
      mode = "n";
      key = "<c-p>";
      action = "<Plug>(YankyPreviousEntry)";
      options.desc = "Select previous entry through yank history";
    }
    {
      mode = "n";
      key = "<c-n>";
      action = "<Plug>(YankyNextEntry)";
      options.desc = "Select next entry through yank history";
    }
    {
      mode = "n";
      key = "]p";
      action = "<Plug>(YankyPutIndentAfterLinewise)";
      options.desc = "Put indented after cursor (linewise)";
    }
    {
      mode = "n";
      key = "[p";
      action = "<Plug>(YankyPutIndentBeforeLinewise)";
      options.desc = "Put indented before cursor (linewise)";
    }
    {
      mode = "n";
      key = "]P";
      action = "<Plug>(YankyPutIndentAfterLinewise)";
      options.desc = "Put indented after cursor (linewise)";
    }
    {
      mode = "n";
      key = "[P";
      action = "<Plug>(YankyPutIndentBeforeLinewise)";
      options.desc = "Put indented before cursor (linewise)";
    }
    {
      mode = "n";
      key = ">p";
      action = "<Plug>(YankyPutIndentAfterShiftRight)";
      options.desc = "Put and indent right";
    }
    {
      mode = "n";
      key = "<p";
      action = "<Plug>(YankyPutIndentAfterShiftLeft)";
      options.desc = "Put and indent left";
    }
    {
      mode = "n";
      key = ">P";
      action = "<Plug>(YankyPutIndentBeforeShiftRight)";
      options.desc = "Put before and indent right";
    }
    {
      mode = "n";
      key = "<P";
      action = "<Plug>(YankyPutIndentBeforeShiftLeft)";
      options.desc = "Put before and indent left";
    }
    {
      mode = "n";
      key = "=p";
      action = "<Plug>(YankyPutAfterFilter)";
      options.desc = "Put after applying a filter";
    }
    {
      mode = "n";
      key = "=P";
      action = "<Plug>(YankyPutBeforeFilter)";
      options.desc = "Put before applying a filter";
    }
  ]
  ++ lib.optionals config.plugins.telescope.enable [
    {
      mode = "n";
      key = "<leader>fy";
      action = "<cmd>Telescope yank_history<cr>";
      options.desc = "Paste from yanky";
    }
  ];

  yankyLazyKeys = map (keymap: {
    __unkeyed-1 = keymap.key;
    __unkeyed-2 = keymap.action;
    mode = keymap.mode or "n";
    inherit (keymap.options) desc;
  }) yankyKeymaps;
in
{
  plugins = {
    yanky = {
      enable = true;

      lazyLoad = {
        settings = {
          keys = lib.mkIf config.plugins.lz-n.enable yankyLazyKeys;
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

  keymaps = lib.mkIf (!config.plugins.lz-n.enable && config.plugins.yanky.enable) yankyKeymaps;
}
