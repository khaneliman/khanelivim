{
  config,
  lib,
  ...
}:
{
  plugins = {
    snacks = {
      enable = true;

      settings = {
        # Need to pass raw to get around being stripped by nixvim
        # Currently, fzf-lua feels better in every way
        picker = {
          layouts = {
            select = {
              layout = {
                relative = "cursor";
                width = 70;
                min_width = 0;
                row = 1;
              };
            };
          };
        };
      };
    };
  };

  keymaps =
    lib.mkIf (config.plugins.snacks.enable && lib.hasAttr "picker" config.plugins.snacks.settings)
      (
        [
          {
            mode = "n";
            key = "<leader>fa";
            action = ''<cmd>lua Snacks.picker.autocmds()<cr>'';
            options = {
              desc = "Find autocmds";
            };
          }
          {
            mode = "n";
            key = "<leader>fc";
            action = ''<cmd>lua Snacks.picker.commands()<cr>'';
            options = {
              desc = "Find commands";
            };
          }
          {
            mode = "n";
            key = "<leader>fC";
            action.__raw = ''
              function()
                require("snacks.picker").files {
                  prompt_title = "Config Files",
                  cwd = vim.fn.stdpath("config"),
                }
              end
            '';
            options = {
              desc = "Find config files";
              silent = true;
            };
          }
          {
            mode = "n";
            key = "<leader>fd";
            action = ''<cmd>lua Snacks.picker.diagnostics_buffer()<cr>'';
            options = {
              desc = "Find buffer diagnostics";
            };
          }
          {
            mode = "n";
            key = "<leader>fD";
            action = ''<cmd>lua Snacks.picker.diagnostics()<cr>'';
            options = {
              desc = "Find workspace diagnostics";
            };
          }
          {
            mode = "n";
            key = "<leader>fe";
            action = ''<cmd>lua Snacks.explorer()<cr>'';
            options = {
              desc = "File Explorer";
            };
          }
          {
            mode = "n";
            key = "<leader>fh";
            action = ''<cmd>lua Snacks.picker.help()<cr>'';
            options = {
              desc = "Find help tags";
            };
          }
          # NOTE: prefer the UI but is lot slower
          {
            mode = "n";
            key = "<leader>fk";
            action = ''<cmd>lua Snacks.picker.keymaps()<cr>'';
            options = {
              desc = "Find keymaps";
            };
          }
          {
            mode = "n";
            key = "<leader>fp";
            action = ''<cmd>lua Snacks.picker.projects()<cr>'';
            options = {
              desc = "Find projects";
            };
          }
          {
            mode = "n";
            key = "<leader>fr";
            action = ''<cmd>lua Snacks.picker.registers()<cr>'';
            options = {
              desc = "Find registers";
            };
          }
          {
            mode = "n";
            key = "<leader>fs";
            action = ''<cmd>lua Snacks.picker.lsp_symbols()<cr>'';
            options = {
              desc = "Find lsp document symbols";
            };
          }
          {
            mode = "n";
            key = "<leader>fS";
            action = ''<CMD>lua Snacks.picker.spelling({layout = { preset = "select" }})<CR>'';
            options = {
              desc = "Find spelling suggestions";
            };
          }
          # Moved to todo-comments module since lazy loading wasn't working
          # {
          #   mode = "n";
          #   key = "<leader>ft";
          #   action = ''<cmd>lua Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" }})<cr>'';
          #   options = {
          #     desc = "Find TODOs";
          #   };
          # }
          {
            mode = "n";
            key = "<leader>fT";
            action = ''<cmd>lua Snacks.picker.colorschemes()<cr>'';
            options = {
              desc = "Find theme";
            };
          }
          {
            mode = "n";
            key = "<leader>f?";
            action = ''<cmd>lua Snacks.picker.grep_buffers()<cr>'';
            options = {
              desc = "Fuzzy find in open buffers";
            };
          }
          {
            mode = "n";
            key = "<leader>fu";
            action = "<cmd>lua Snacks.picker.undo()<cr>";
            options = {
              desc = "Undo History";
            };
          }
          # Profiler
          {
            mode = "n";
            key = "<leader>D";
            action = ''<cmd>lua Snacks.profiler.toggle()<cr>'';
            options = {
              desc = "Toggle Neovim profiler";
            };
          }
        ]
        ++ lib.optionals (!config.plugins.fzf-lua.enable) [
          {
            mode = "n";
            key = "<leader>f'";
            action = ''<cmd>lua Snacks.picker.marks()<cr>'';
            options = {
              desc = "Find marks";
            };
          }
          {
            mode = "n";
            key = "<leader>f/";
            action = ''<cmd>lua Snacks.picker.lines()<cr>'';
            options = {
              desc = "Fuzzy find in current buffer";
            };
          }
          {
            mode = "n";
            key = "<leader>f<CR>";
            action = ''<cmd>lua Snacks.picker.resume()<cr>'';
            options = {
              desc = "Resume find";
            };
          }
          {
            mode = "n";
            key = "<leader>fb";
            action = ''<cmd>lua Snacks.picker.buffers()<cr>'';
            options = {
              desc = "Find buffers";
            };
          }
          {
            mode = "n";
            key = "<leader>ff";
            action = ''<cmd>lua Snacks.picker.files()<cr>'';
            options = {
              desc = "Find files";
            };
          }
          {
            mode = "n";
            key = "<leader>fm";
            action = ''<cmd>lua Snacks.picker.man()<cr>'';
            options = {
              desc = "Find man pages";
            };
          }
          {
            mode = "n";
            key = "<leader>fo";
            action = ''<cmd>lua Snacks.picker.recent()<cr>'';
            options = {
              desc = "Find old files";
            };
          }
          {
            mode = "n";
            key = "<leader>fq";
            action = ''<cmd>lua Snacks.picker.qflist()<cr>'';
            options = {
              desc = "Find quickfix";
            };
          }
          {
            mode = "n";
            key = "<leader>ld";
            action = ''<cmd>lua Snacks.picker.lsp_definitions()<cr>'';
            options = {
              desc = "Goto Definition";
            };
          }
          {
            mode = "n";
            key = "<leader>li";
            action = ''<cmd>lua Snacks.picker.lsp_implementation()<cr>'';
            options = {
              desc = "Goto Implementation";
            };
          }
          {
            mode = "n";
            key = "<leader>lD";
            action = ''<cmd>lua Snacks.picker.lsp_references()<cr>'';
            options = {
              desc = "Find references";
            };
          }
          {
            mode = "n";
            key = "<leader>lt";
            action = ''<cmd>lua Snacks.picker.lsp_type_definitions()<cr>'';
            options = {
              desc = "Goto Type Definition";
            };
          }
          {
            mode = "n";
            key = "<leader>fw";
            action = "<cmd>lua Snacks.picker.grep()<cr>";
            options = {
              desc = "Live grep";
            };
          }
          # {
          #   mode = "n";
          #   key = "<leader>gB";
          #   action = ''<cmd>lua Snacks.picker.git_branches()<cr>'';
          #   options = {
          #     desc = "Find git branches";
          #   };
          # }
          # {
          #   mode = "n";
          #   key = "<leader>gC";
          #   action = ''<cmd>lua Snacks.picker.git_commits()<cr>'';
          #   options = {
          #     desc = "Find git commits";
          #   };
          # }
          {
            mode = "n";
            key = "<leader>gs";
            action = ''<cmd>lua Snacks.picker.git_status()<cr>'';
            options = {
              desc = "Find git status";
            };
          }
          # {
          #   mode = "n";
          #   key = "<leader>gS";
          #   action = ''<cmd>lua Snacks.picker.git_stash()<cr>'';
          #   options = {
          #     desc = "Find git stashes";
          #   };
          # }
          # {
          #   mode = "n";
          #   key = "<leader>la";
          #   action = ''<cmd>lua Snacks.picker.lsp_code_actions()<cr>'';
          #   options = {
          #     desc = "Code Action";
          #   };
          # }
        ]
      );
}
