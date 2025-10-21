{
  config,
  lib,
  ...
}:
{
  imports = [
    ./file-browser.nix
    ./frecency.nix
    ./fzf-native.nix
    ./live_grep.nix
    ./manix.nix
    ./ui-select.nix
    ./undo.nix
  ];

  plugins.telescope = {
    enable = config.khanelivim.picker.engine == "telescope";

    lazyLoad.settings.cmd = [
      "Telescope"
    ]
    ++ lib.optionals config.plugins.noice.enable [
      "Noice telescope"
    ];

    highlightTheme = "Catppuccin Macchiato";

    keymaps = lib.mkIf (config.khanelivim.picker.engine == "telescope") {
      "<leader>f'" = {
        action = "marks";
        options.desc = "View marks";
      };
      "<leader>f/" = {
        action = "current_buffer_fuzzy_find";
        options.desc = "Fuzzy find in current buffer";
      };
      "<leader>f<CR>" = {
        action = "resume";
        options.desc = "Resume action";
      };
      "<leader>fa" = {
        action = "autocommands";
        options.desc = "View autocommands";
      };
      "<leader>fc" = {
        action = "commands";
        options.desc = "View commands";
      };
      "<leader>fb" = {
        action = "buffers";
        options.desc = "View buffers";
      };
      # "<leader>fc" = {
      #   action = "grep_string";
      #   options.desc = "Grep string";
      # };
      "<leader>fd" = {
        action = "diagnostics";
        options.desc = "View diagnostics";
      };
      "<leader>ff" = {
        action = "find_files";
        options.desc = "Find files";
      };
      "<leader>fh" = {
        action = "help_tags";
        options.desc = "View help tags";
      };
      "<leader>fk" = {
        action = "keymaps";
        options.desc = "View keymaps";
      };
      "<leader>fm" = {
        action = "man_pages";
        options.desc = "View man pages";
      };
      "<leader>fo" = {
        action = "oldfiles";
        options.desc = "View old files";
      };
      "<leader>fr" = {
        action = "registers";
        options.desc = "View registers";
      };
      "<leader>fs" = {
        action = "lsp_document_symbols";
        options.desc = "Search symbols";
      };
      "<leader>fq" = {
        action = "quickfix";
        options.desc = "Search quickfix";
      };
      # "<leader>gC" = {
      #   action = "git_bcommits";
      #   options.desc = "View git bcommits";
      # };
      "<leader>gfb" = {
        action = "git_branches";
        options.desc = "Git Branches";
      };
      "<leader>gfc" = {
        action = "git_commits";
        options.desc = "Git Commits";
      };
      "<leader>gfs" = {
        action = "git_status";
        options.desc = "Git Status";
      };
      "<leader>gfh" = {
        action = "git_stash";
        options.desc = "Git Stashes";
      };
    };

    settings = {
      defaults = {
        file_ignore_patterns = [
          "^.git/"
          "^.mypy_cache/"
          "^__pycache__/"
          "^output/"
          "^data/"
          "%.ipynb"
        ];
        set_env.COLORTERM = "truecolor";
      };

      pickers = {
        colorscheme = {
          enable_preview = true;
        };
      };
    };
  };

  keymaps = lib.mkIf config.plugins.telescope.enable (
    # Fzf-lua missing keymaps
    lib.optionals
      (
        config.plugins.fzf-lua.enable
        && (
          !config.plugins.snacks.enable
          || (config.plugins.snacks.enable && !lib.hasAttr "picker" config.plugins.snacks.settings)
        )
      )
      [
        {
          mode = "n";
          key = "<leader>fF";
          action.__raw = ''
            function()
              vim.cmd('Telescope find_files hidden=true no_ignore=true')
            end
          '';
          options = {
            desc = "Find all files";
            silent = true;
          };
        }
        {
          mode = "n";
          key = "<leader>fW";
          action.__raw = ''
            function()
              vim.cmd('Telescope live_grep additional_args={"--hidden","--no-ignore"}')
            end
          '';
          options = {
            desc = "Find words in all files";
            silent = true;
          };
        }
      ]
    # Only use as the last fallback after snacks and fzf-lua
    ++
      lib.optionals
        (
          !config.plugins.fzf-lua.enable
          && (
            !config.plugins.snacks.enable
            || (config.plugins.snacks.enable && !lib.hasAttr "picker" config.plugins.snacks.settings)
          )
        )
        [
          {
            mode = "n";
            key = "<leader>fC";
            action.__raw = ''
              function()
                vim.cmd(string.format('Telescope find_files prompt_title="Config Files" cwd="%s" follow=true', vim.fn.stdpath("config")))
              end
            '';
            options = {
              desc = "Find config files";
              silent = true;
            };
          }
          {
            mode = "n";
            key = "<leader>fT";
            action.__raw = ''
              function()
                vim.cmd('Telescope colorscheme enable_preview=true')
              end
            '';
            options = {
              desc = "Find theme";
              silent = true;
            };
          }
          {
            mode = "n";
            key = "<leader>f?";
            action.__raw = ''
              function()
                vim.cmd('Telescope live_grep grep_open_files=true')
              end
            '';
            options = {
              desc = "Find words in all open buffers";
              silent = true;
            };
          }
        ]
  );
}
