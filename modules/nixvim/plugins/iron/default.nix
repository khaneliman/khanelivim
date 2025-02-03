{
  config,
  lib,
  pkgs,
  ...
}:
{
  extraPlugins = with pkgs.vimPlugins; [
    iron-nvim
  ];

  plugins.lz-n = {
    plugins = [
      {
        __unkeyed-1 = "iron.nvim";
        cmd = [
          "IronRepl"
          "IronReplHere"
        ];
        after = # Lua
          ''
            function()
              require ("iron.core").setup({
                config = {
                    scratch_repl = true,
                    repl_definition = {
                      python = {
                        command = { "${lib.getExe pkgs.python3}" },
                        format = require("iron.fts.common").bracketed_paste_python
                      },
                      nix = {
                        command = { "nix", "repl" }
                      }
                    },
                  },
                  keymaps = {
                    send_motion = "<space>sm",
                    visual_send = "<space>sv",
                    send_file = "<space>sf",
                    send_line = "<space>sl",
                    send_paragraph = "<space>sp",
                    send_until_cursor = "<space>su",
                    send_mark = "<space>ms",
                    mark_motion = "<space>mc",
                    mark_visual = "<space>mc",
                    remove_mark = "<space>md",
                    cr = "<space>s<cr>",
                    interrupt = "<space>s<space>",
                    exit = "<space>sq",
                    clear = "<space>sc",
                  },
                  highlight = {
                    italic = true
                  },
                  ignore_blank_lines = true,
              })
            end
          '';
      }
    ];
  };

  plugins.which-key.settings.spec =
    lib.optionals (builtins.elem pkgs.vimPlugins.iron-nvim config.extraPlugins)
      [
        {
          __unkeyed-1 = "<leader>s";
          group = "REPL Send";
          icon = "󱠥";
        }
        {
          __unkeyed-1 = "<leader>m";
          group = "REPL Mark";
          icon = "󱠥";
        }
      ];
}
