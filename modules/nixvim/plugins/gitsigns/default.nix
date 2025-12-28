{ config, lib, ... }:
{
  plugins = {
    gitsigns = {
      enable = lib.elem "gitsigns" config.khanelivim.git.integrations;

      lazyLoad.settings.event = [
        "BufReadPost"
        "BufNewFile"
      ];

      settings = {
        current_line_blame = true;

        current_line_blame_opts = {
          delay = 500;

          ignore_blank_lines = true;
          ignore_whitespace = true;
          virt_text = true;
          virt_text_pos = "eol";
        };

        signcolumn = true;
      };
    };

    which-key.settings.spec = lib.optionals config.plugins.gitsigns.enable [
      {
        __unkeyed-1 = "<leader>gh";
        group = "Hunks";
        icon = " ";
        mode = [
          "n"
          "v"
        ];
      }
      {
        __unkeyed-1 = "<leader>ug";
        group = "Git";
      }
    ];
  };

  keymaps = lib.mkIf config.plugins.gitsigns.enable (
    [
      # Navigation
      {
        mode = "n";
        key = "]c";
        action.__raw = ''
          function()
            if vim.wo.diff then
              return ']c'
            end
            vim.schedule(function()
              require('gitsigns').nav_hunk('next')
            end)
            return '<Ignore>'
          end
        '';
        options = {
          expr = true;
          desc = "Next Hunk";
        };
      }
      {
        mode = "n";
        key = "[c";
        action.__raw = ''
          function()
            if vim.wo.diff then
              return '[c'
            end
            vim.schedule(function()
              require('gitsigns').nav_hunk('prev')
            end)
            return '<Ignore>'
          end
        '';
        options = {
          expr = true;
          desc = "Previous Hunk";
        };
      }
      # Git Actions
      {
        mode = "n";
        key = "<leader>gS";
        action.__raw = ''
          function()
            require('gitsigns').stage_buffer()
            local file = vim.fn.expand('%')
            vim.notify('Staged ' .. file, vim.log.levels.INFO, { title = 'Gitsigns' })
          end
        '';
        options = {
          desc = "Stage Buffer";
        };
      }
      {
        mode = "n";
        key = "<leader>gR";
        action = "<cmd>Gitsigns reset_buffer<CR>";
        options = {
          desc = "Reset Buffer";
        };
      }
      {
        mode = "n";
        key = "<leader>gU";
        action.__raw = ''
          function()
            local file = vim.fn.expand('%')
            vim.fn.system('git restore --staged ' .. file)
            require('gitsigns').refresh()
            vim.notify('Unstaged ' .. file, vim.log.levels.INFO, { title = 'Gitsigns' })
          end
        '';
        options = {
          desc = "Unstage Buffer";
        };
      }
      {
        mode = "n";
        key = "<leader>gb";
        action.__raw = "function() require('gitsigns').blame_line{full=true} end";
        options = {
          desc = "Blame Line";
        };
      }
      # Hunk Actions
      {
        mode = "n";
        key = "<leader>ghs";
        action.__raw = ''
          function()
            require('gitsigns').stage_hunk()
            vim.notify('Hunk staged', vim.log.levels.INFO, { title = 'Gitsigns' })
          end
        '';
        options = {
          desc = "Stage Hunk";
        };
      }
      {
        mode = "v";
        key = "<leader>ghs";
        action.__raw = ''
          function()
            require('gitsigns').stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
            vim.notify('Selected lines staged', vim.log.levels.INFO, { title = 'Gitsigns' })
          end
        '';
        options = {
          desc = "Stage Hunk";
        };
      }
      {
        mode = "n";
        key = "<leader>ghr";
        action = "<cmd>Gitsigns reset_hunk<CR>";
        options = {
          desc = "Reset Hunk";
        };
      }
      {
        mode = "v";
        key = "<leader>ghr";
        action = ":Gitsigns reset_hunk<CR>";
        options = {
          desc = "Reset Hunk";
        };
      }
      {
        mode = [
          "n"
          "v"
        ];
        key = "<leader>ghu";
        action.__raw = ''
          function()
            require('gitsigns').undo_stage_hunk()
            vim.notify('Hunk unstaged', vim.log.levels.INFO, { title = 'Gitsigns' })
          end
        '';
        options = {
          desc = "Undo Stage Hunk";
        };
      }
      {
        mode = [
          "n"
          "v"
        ];
        key = "<leader>ghp";
        action = "<cmd>Gitsigns preview_hunk<CR>";
        options = {
          desc = "Preview Hunk";
        };
      }
      {
        mode = "n";
        key = "<leader>ghi";
        action = "<cmd>Gitsigns preview_hunk_inline<CR>";
        options = {
          desc = "Preview Hunk Inline";
        };
      }
      {
        mode = "n";
        key = "<leader>ghQ";
        action = "<cmd>Gitsigns setqflist all<CR>";
        options = {
          desc = "Set Quickfix List All";
        };
      }
      {
        mode = "n";
        key = "<leader>ghq";
        action = "<cmd>Gitsigns setqflist<CR>";
        options = {
          desc = "Set Quickfix List";
        };
      }
      # Toggles
      {
        mode = "n";
        key = "<leader>ugb";
        action = "<cmd>Gitsigns toggle_current_line_blame<CR>";
        options = {
          desc = "Toggle Blame";
        };
      }
      {
        mode = "n";
        key = "<leader>ugw";
        action = "<cmd>Gitsigns toggle_word_diff<CR>";
        options = {
          desc = "Toggle Word Diff";
        };
      }
      # Text object
      {
        mode = [
          "o"
          "x"
        ];
        key = "ih";
        action = "<cmd>Gitsigns select_hunk<CR>";
        options = {
          desc = "Select Hunk";
        };
      }
    ]
    ++ [
      # Gitsigns diff commands (always available when gitsigns is enabled)
      {
        mode = "n";
        key = "<leader>gdg";
        action = "<cmd>Gitsigns diffthis<CR>";
        options = {
          desc = "Gitsigns Diff This";
        };
      }
      {
        mode = "n";
        key = "<leader>gdG";
        action = "<cmd>Gitsigns diffthis ~<CR>";
        options = {
          desc = "Gitsigns Diff This ~";
        };
      }
    ]
    ++ lib.optionals (config.khanelivim.git.diffViewer == "gitsigns") [
      # Primary diff shortcut when gitsigns is the chosen diff viewer
      {
        mode = "n";
        key = "<leader>gD";
        action.__raw = ''
          function()
            if vim.wo.diff then
              vim.cmd('diffoff')
            else
              require('gitsigns').diffthis()
            end
          end
        '';
        options = {
          desc = "Toggle Diff (Primary)";
        };
      }
    ]
  );
}
