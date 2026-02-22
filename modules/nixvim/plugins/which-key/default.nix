{
  config,
  lib,
  ...
}:
{
  plugins.which-key = lib.mkIf (config.khanelivim.ui.keybindingHelp == "which-key") {
    # which-key.nvim documentation
    # See: https://github.com/folke/which-key.nvim
    enable = true;

    lazyLoad.settings.event = "DeferredUIEnter";

    settings = {
      spec = [
        {
          __unkeyed-1 = "<leader>b";
          group = "Buffers";
        }
        {
          __unkeyed-1 = "<leader>bs";
          group = "Sort";
          icon = "󰒺 ";
        }
        {
          __unkeyed-1 = "<leader>f";
          group = "Find";
        }
        {
          __unkeyed-1 = "<leader>g";
          group = "Git";
          mode = [
            "n"
            "v"
          ];
        }
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
          __unkeyed-1 = "<leader>gf";
          group = "Git Find";
        }
        {
          __unkeyed-1 = "<leader>l";
          group = "LSP";
        }
        {
          __unkeyed-1 = "<leader>s";
          group = "Search";
        }
        {
          __unkeyed-1 = "<leader>u";
          group = "UI/UX";
        }
        {
          __unkeyed-1 = "<leader>ua";
          group = "Appearance";
        }
        {
          __unkeyed-1 = "<leader>uc";
          group = "Completion";
          icon = "󰘦";
        }
        {
          __unkeyed-1 = "<leader>ud";
          group = "Diagnostics & Debugging";
          icon = "";
        }
        {
          __unkeyed-1 = "<leader>ue";
          group = "Editor Toggles";
          icon = "";
        }
        {
          __unkeyed-1 = "<leader>ug";
          group = "Git UI";
          icon = "";
        }
        {
          __unkeyed-1 = "<leader>up";
          group = "Performance & Profiling";
          icon = "󰓅";
        }
        {
          __unkeyed-1 = "<leader>un";
          group = "Notifications";
          icon = "";
        }
        {
          __unkeyed-1 = "<leader>us";
          group = "Scroll & Screen";
          icon = "󰍹";
        }
        {
          __unkeyed-1 = "<leader>ut";
          group = "Treesitter & Syntax";
          icon = "";
        }
        {
          __unkeyed-1 = "<leader>w";
          icon = "";
        }
        {
          __unkeyed-1 = "<leader>W";
          icon = "󰽃";
        }
        {
          __unkeyed-1 = "<leader>/";
          icon = "";
        }
      ]
      ++
        lib.optionals
          (
            config.plugins.avante.enable
            || config.plugins.claudecode.enable
            || config.plugins.codecompanion.enable
          )
          [
            {
              __unkeyed-1 = "<leader>a";
              group = "AI Assistant";
              icon = "";
              mode = [
                "n"
                "v"
              ];
            }
          ]
      ++ lib.optionals (config.plugins.comment-box.enable || config.plugins.codesnap.enable) [
        {
          __unkeyed-1 = "<leader>c";
          group = "Code & Comments";
          icon = "󰄄 ";
          mode = [
            "n"
            "x"
            "v"
          ];
        }
      ]
      ++ lib.optionals config.plugins.dap.enable [
        {
          __unkeyed-1 = "<leader>d";
          group = "Debug";
          mode = [
            "n"
            "x"
            "v"
          ];
        }
      ]
      ++ lib.optionals config.plugins.fff.enable [
        {
          __unkeyed-1 = "<leader>fF";
          group = "File Filter";
          icon = "󰈞";
        }
      ]
      ++ lib.optionals config.plugins.git-conflict.enable [
        {
          __unkeyed-1 = "<leader>gc";
          group = "Conflicts";
          icon = "";
        }
      ]
      ++ lib.optionals (config.khanelivim.git.diffViewer != "none") [
        {
          __unkeyed-1 = "<leader>gd";
          group = "Diff";
          icon = "";
        }
      ]
      ++ lib.optionals (config.plugins.rest.enable || config.plugins.kulala.enable) [
        {
          __unkeyed-1 = "<leader>h";
          group = "HTTP";
          icon = "🌐";
        }
        {
          __unkeyed-1 = "<leader>he";
          group = "Environment";
        }
      ]
      ++ lib.optionals config.plugins.jj.enable [
        {
          __unkeyed-1 = "<leader>j";
          group = "Jujutsu";
          icon = "󱗘 ";
        }
        {
          __unkeyed-1 = "<leader>jb";
          group = "Bookmark";
        }
        {
          __unkeyed-1 = "<leader>jp";
          group = "Picker";
        }
      ]
      ++ lib.optionals config.plugins.glance.enable [
        {
          __unkeyed-1 = "<leader>lg";
          group = "Glance";
          icon = "󰍉";
        }
      ]
      ++ lib.optionals config.plugins.multicursor.enable [
        {
          __unkeyed-1 = "<leader>m";
          group = "Multicursor";
          icon = "󰗧";
          mode = [
            "n"
            "v"
          ];
        }
      ]
      ++ lib.optionals config.plugins.snacks.enable [
        {
          __unkeyed-1 = "<leader>n";
          group = "Notes";
          icon = " ";
        }
      ]
      ++ lib.optionals config.plugins.neorg.enable [
        {
          __unkeyed-1 = "<leader>no";
          group = "Neorg";
          icon = "";
        }
      ]
      ++ lib.optionals (config.plugins.glow.enable || config.plugins.markdown-preview.enable) [
        {
          __unkeyed-1 = "<leader>p";
          group = "Preview";
          icon = " ";
        }
      ]
      ++ lib.optionals config.plugins.refactoring.enable [
        {
          __unkeyed-1 = "<leader>r";
          group = "Refactor";
          mode = [
            "n"
            "v"
          ];
        }
      ]
      ++ lib.optionals (config.plugins.overseer.enable || config.plugins.rustaceanvim.enable) [
        {
          __unkeyed-1 = "<leader>R";
          group = "Run";
          icon = "";
        }
      ]
      ++ lib.optionals (config.plugins.persistence.enable || config.plugins.mini.enable) [
        {
          __unkeyed-1 = "<leader>S";
          group = "Sessions";
          icon = "󰘛";
        }
      ]
      ++ lib.optionals config.plugins.neotest.enable [
        {
          __unkeyed-1 = "<leader>t";
          group = "Test";
          icon = "󰙨";
        }
      ]
      ++ lib.optionals (config.plugins.hardtime.enable || config.plugins.precognition.enable) [
        {
          __unkeyed-1 = "<leader>v";
          group = "Vim training";
          icon = "󱛊";
        }
      ]
      ++ lib.optionals config.plugins.trouble.enable [
        {
          __unkeyed-1 = "<leader>x";
          group = "Trouble";
          icon = "";
        }
      ];

      replace = {
        # key = [
        #   [
        #     "<Space>"
        #     "SPC"
        #   ]
        # ];

        desc = [
          [
            "<space>"
            "SPACE"
          ]
          [
            "<leader>"
            "SPACE"
          ]
          [
            "<[cC][rR]>"
            "RETURN"
          ]
          [
            "<[tT][aA][bB]>"
            "TAB"
          ]
          [
            "<[bB][sS]>"
            "BACKSPACE"
          ]
        ];
      };
      win = {
        border = "single";
      };

      # preset = "helix";
    };
  };
}
