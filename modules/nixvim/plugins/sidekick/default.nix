{
  config,
  lib,
  ...
}:
let
  aiPlugins = config.khanelivim.ai.plugins;
  sidekickClaude = builtins.elem "claudecode" aiPlugins;
  sidekickCopilot = builtins.elem "copilot" aiPlugins || builtins.elem "copilot-lsp" aiPlugins;
  sidekickGemini = builtins.elem "codecompanion" aiPlugins || builtins.elem "avante" aiPlugins;
  sidekickCodex = builtins.elem "codex" aiPlugins;
  sidekickOpencode = builtins.elem "opencode" aiPlugins;
in
{
  config = {
    plugins = {
      sidekick = {
        enable = builtins.elem "sidekick" config.khanelivim.ai.plugins;

        lazyLoad.settings.keys = [
          {
            __unkeyed-1 = "<leader>ast";
            desc = "Sidekick Toggle";
          }
          {
            __unkeyed-1 = "<leader>asp";
            mode = [
              "n"
              "v"
            ];
            desc = "Ask Prompt";
          }
        ]
        ++ lib.optionals sidekickClaude [
          {
            __unkeyed-1 = "<leader>asc";
            mode = [
              "n"
              "v"
            ];
            desc = "Claude Toggle";
          }
        ]
        ++ lib.optionals sidekickCopilot [
          {
            __unkeyed-1 = "<leader>asC";
            mode = [
              "n"
              "v"
            ];
            desc = "Copilot Toggle";
          }
        ]
        ++ lib.optionals sidekickGemini [
          {
            __unkeyed-1 = "<leader>asg";
            mode = [
              "n"
              "v"
            ];
            desc = "Gemini Toggle";
          }
        ]
        ++ lib.optionals sidekickOpencode [
          {
            __unkeyed-1 = "<leader>aso";
            mode = [
              "n"
              "v"
            ];
            desc = "Opencode Toggle";
          }
        ]
        ++ lib.optionals sidekickCodex [
          {
            __unkeyed-1 = "<leader>asx";
            mode = [
              "n"
              "v"
            ];
            desc = "Codex Toggle";
          }
        ];

        settings = {
          mux = {
            enabled = true;
          };
        };
      };

      which-key.settings.spec = lib.optionals config.plugins.sidekick.enable [
        {
          __unkeyed-1 = "<leader>as";
          group = "Sidekick";
          icon = "🤖";
          mode = [
            "n"
            "v"
          ];
        }
      ];
    };

    keymaps =
      (lib.optionals (!config.plugins.blink-cmp.enable && config.plugins.sidekick.enable) [
        {
          mode = [
            "n"
            "i"
          ];
          key = "<Tab>";
          action.__raw = ''
            function()
              -- if there is a next edit, jump to it, otherwise apply it if any
              if not require("sidekick").nes_jump_or_apply() then
                return "<Tab>" -- fallback to normal tab
              end
            end
          '';
          options = {
            expr = true;
            desc = "Goto/Apply Next Edit Suggestion";
          };
        }
      ])
      ++ (lib.optionals (config.plugins.blink-cmp.enable && config.plugins.sidekick.enable) [
        {
          mode = "n";
          key = "<Tab>";
          action.__raw = ''
            function()
              -- Try sidekick NES first
              if require("sidekick").nes_jump_or_apply() then
                return
              end
              -- Try copilot-lsp NES if available
              ${lib.optionalString config.plugins.copilot-lua.enable ''
                if vim.b[vim.api.nvim_get_current_buf()].nes_state then
                  require("copilot-lsp.nes").apply_pending_nes()
                  require("copilot-lsp.nes").walk_cursor_end_edit()
                  return
                end
              ''}
              -- fallback to normal tab
              return "<Tab>"
            end
          '';
          options = {
            expr = true;
            desc = "Goto/Apply Next Edit Suggestion";
          };
        }
      ])
      ++ [
        {
          mode = "n";
          key = "<leader>ast";
          action.__raw = "function() require('sidekick.cli').toggle({ focus = true }) end";
          options.desc = "Sidekick Toggle";
        }
        {
          mode = [
            "n"
            "v"
          ];
          key = "<leader>asp";
          action.__raw = "function() require('sidekick.cli').prompt() end";
          options.desc = "Ask Prompt";
        }
      ]
      ++ lib.optionals sidekickClaude [
        {
          mode = [
            "n"
            "v"
          ];
          key = "<leader>asc";
          action.__raw = "function() require('sidekick.cli').toggle({ name = 'claude', focus = true }) end";
          options.desc = "Claude Toggle";
        }
      ]
      ++ lib.optionals sidekickCopilot [
        {
          mode = [
            "n"
            "v"
          ];
          key = "<leader>asC";
          action.__raw = "function() require('sidekick.cli').toggle({ name = 'copilot', focus = true }) end";
          options.desc = "Copilot Toggle";
        }
      ]
      ++ lib.optionals sidekickGemini [
        {
          mode = [
            "n"
            "v"
          ];
          key = "<leader>asg";
          action.__raw = "function() require('sidekick.cli').toggle({ name = 'gemini', focus = true }) end";
          options.desc = "Gemini Toggle";
        }
      ]
      ++ lib.optionals sidekickOpencode [
        {
          mode = [
            "n"
            "v"
          ];
          key = "<leader>aso";
          action.__raw = "function() require('sidekick.cli').toggle({ name = 'opencode', focus = true }) end";
          options.desc = "Opencode Toggle";
        }
      ]
      ++ lib.optionals sidekickCodex [
        {
          mode = [
            "n"
            "v"
          ];
          key = "<leader>asx";
          action.__raw = "function() require('sidekick.cli').toggle({ name = 'codex', focus = true }) end";
          options.desc = "Codex Toggle";
        }
      ];
  };
}
