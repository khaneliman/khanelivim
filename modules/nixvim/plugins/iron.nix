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

  extraConfigLua = # Lua
    ''
      local iron = require ("iron.core")
      iron.setup {
        config = {
            -- Whether a repl should be discarded or not
            scratch_repl = true,
            -- Your repl definitions come here
            repl_definition = {
              -- sh = {
              --   command = {"zsh"}
              -- },
              python = {
                command = { "${lib.getExe pkgs.python3}" },
                format = require("iron.fts.common").bracketed_paste_python
              },
              nix = {
                command = { "nix", "repl" }
              }
            },
            -- How the repl window will be displayed
            -- See below for more information
            -- repl_open_cmd = require('iron.view').bottom(40),
          },
          -- Iron doesn't set keymaps by default anymore.
          -- You can set them here or manually add keymaps to the functions in iron.core
          keymaps = {
            send_motion = "<space>sc",
            visual_send = "<space>sc",
            send_file = "<space>sf",
            send_line = "<space>sl",
            send_paragraph = "<space>sp",
            send_until_cursor = "<space>su",
            send_mark = "<space>sm",
            mark_motion = "<space>mc",
            mark_visual = "<space>mc",
            remove_mark = "<space>md",
            cr = "<space>s<cr>",
            interrupt = "<space>s<space>",
            exit = "<space>sq",
            clear = "<space>cl",
          },
          -- If the highlight is on, you can change how it looks
          -- For the available options, check nvim_set_hl
          highlight = {
            italic = true
          },
          ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
      }
    '';

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
