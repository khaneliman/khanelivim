{
  config,
  lib,
  pkgs,
  ...
}:
{
  plugins.vscode-diff = {
    enable =
      config.khanelivim.git.diffViewer == "codediff"
      || builtins.elem "codediff" config.khanelivim.git.integrations;
    package = pkgs.vimPlugins.codediff-nvim;

    lazyLoad.settings = {
      cmd = "CodeDiff";
    };

    settings = {
      highlights = {
        line_insert = "DiffAdd";
        line_delete = "DiffDelete";
        char_brightness = 1.4;
      };

      diff = {
        disable_inlay_hints = true;
        max_computation_time_ms = 5000;
      };

      explorer = {
        position = "left";
        width = 40;
        indent_markers = true;
        view_mode = "tree";
      };

      keymaps = {
        view = {
          quit = "q";
          toggle_explorer = "<leader>b";
          next_hunk = "]c";
          prev_hunk = "[c";
          next_file = "]f";
          prev_file = "[f";
          diff_get = "do";
          diff_put = "dp";
        };
        explorer = {
          select = "<CR>";
          hover = "K";
          refresh = "R";
          toggle_view_mode = "i";
        };
      };
    };
  };

  keymaps =
    lib.optionals config.plugins.vscode-diff.enable [
      {
        mode = "n";
        key = "<leader>gdv";
        action = "<cmd>CodeDiff<CR>";
        options = {
          desc = "VSCode Diff (CodeDiff)";
        };
      }
      {
        mode = "n";
        key = "<leader>gdV";
        action = "<cmd>CodeDiff HEAD~1<CR>";
        options = {
          desc = "VSCode Diff (-1)";
        };
      }
      {
        mode = "n";
        key = "<leader>gs";
        action = "<cmd>CodeDiff<CR>";
        options = {
          desc = "Git Status (CodeDiff)";
        };
      }
    ]
    ++ lib.optionals (config.khanelivim.git.diffViewer == "codediff") [
      {
        mode = "n";
        key = "<leader>gD";
        action = "<cmd>CodeDiff<CR>";
        options = {
          desc = "Toggle Diff (Primary)";
        };
      }
    ];
}
