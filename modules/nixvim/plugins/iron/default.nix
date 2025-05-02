{
  lib,
  pkgs,
  ...
}:
{
  plugins = {
    iron = {
      enable = true;

      lazyLoad.settings.cmd = [
        "IronRepl"
        "IronReplHere"
      ];

      settings = {
        scratch_repl = true;
        repl_definition = {
          python = {
            command = [ "${lib.getExe pkgs.python3}" ];
            format.__raw = ''
              require("iron.fts.common").bracketed_paste_python
            '';
          };
          nix = {
            command = [
              "nix"
              "repl"
            ];
          };
        };
        keymaps = {
          send_motion = "<space>sm";
          visual_send = "<space>sv";
          send_file = "<space>sf";
          send_line = "<space>sl";
          send_paragraph = "<space>sp";
          send_until_cursor = "<space>su";
          send_mark = "<space>ms";
          mark_motion = "<space>mc";
          mark_visual = "<space>mc";
          remove_mark = "<space>md";
          cr = "<space>s<cr>";
          interrupt = "<space>s<space>";
          exit = "<space>sq";
          clear = "<space>sc";
        };
        highlight = {
          italic = true;
        };
        ignore_blank_lines = true;
      };
    };

    which-key.settings.spec = [
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
  };
}
