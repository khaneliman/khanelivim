{
  config,
  lib,
  ...
}:
{
  config = {
    plugins = {
      sidekick = {
        # sidekick.nvim documentation
        # See: https://github.com/folke/sidekick.nvim
        enable = builtins.elem "sidekick" config.khanelivim.ai.plugins;

        lazyLoad.settings.keys = [
          {
            __unkeyed-1 = "<leader>ast";
            desc = "Sidekick Toggle";
          }
          {
            __unkeyed-1 = "<leader>asP";
            mode = [
              "n"
              "v"
            ];
            desc = "Ask Prompt";
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
      ++ lib.optionals config.plugins.sidekick.enable [
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
          key = "<leader>asP";
          action.__raw = "function() require('sidekick.cli').prompt() end";
          options.desc = "Ask Prompt";
        }
      ];

    autoCmd = lib.optionals config.plugins.sidekick.enable [
      {
        event = "VimEnter";
        callback.__raw = ''
          function()
            local opts = function(desc)
              return { desc = desc }
            end

            local map = function(mode, key, provider, binary, desc)
              if vim.fn.executable(binary) ~= 1 then
                return
              end

              vim.keymap.set(mode, key, function()
                ${lib.optionalString config.plugins.lz-n.enable "require('lz.n').trigger_load('sidekick.nvim')"}
                require("sidekick.cli").toggle({ name = provider, focus = true })
              end, opts(desc))
            end

            map({ "n", "v" }, "<leader>asc", "claude", "claude", "Claude Toggle")
            map({ "n", "v" }, "<leader>asC", "copilot", "copilot", "Copilot Toggle")
            map({ "n", "v" }, "<leader>asg", "gemini", "gemini", "Gemini Toggle")
            map({ "n", "v" }, "<leader>aso", "opencode", "opencode", "Opencode Toggle")
            map({ "n", "v" }, "<leader>asx", "codex", "codex", "Codex Toggle")
            map({ "n", "v" }, "<leader>asp", "pi", "pi", "PI Coding Agent Toggle")
          end
        '';
      }
    ];
  };
}
