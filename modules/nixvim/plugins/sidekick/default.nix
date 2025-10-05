{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = {
    plugins = {
      sidekick = {
        enable = true;

        package = pkgs.vimPlugins.sidekick-nvim.overrideAttrs {
          version = "2025-10-03";
          src = pkgs.fetchFromGitHub {
            owner = "folke";
            repo = "sidekick.nvim";
            rev = "0ab6a23b779e208c3733c48a380bf35e3ec1d49d";
            sha256 = "0spx8q16cvrp9pydpq4p0vbfkvm5mpi7y3byi3aizy67acvgjw3k";
          };
        };

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
          action.__raw = "function() require('sidekick.cli').select_prompt() end";
          options.desc = "Ask Prompt";
        }
        {
          mode = [
            "n"
            "v"
          ];
          key = "<leader>asc";
          action.__raw = "function() require('sidekick.cli').toggle({ name = 'claude', focus = true }) end";
          options.desc = "Claude Toggle";
        }
        {
          mode = [
            "n"
            "v"
          ];
          key = "<leader>asC";
          action.__raw = "function() require('sidekick.cli').toggle({ name = 'copilot', focus = true }) end";
          options.desc = "Copilot Toggle";
        }
        {
          mode = [
            "n"
            "v"
          ];
          key = "<leader>asg";
          action.__raw = "function() require('sidekick.cli').toggle({ name = 'gemini', focus = true }) end";
          options.desc = "Gemini Toggle";
        }
        {
          mode = [
            "n"
            "v"
          ];
          key = "<leader>aso";
          action.__raw = "function() require('sidekick.cli').toggle({ name = 'opencode', focus = true }) end";
          options.desc = "Opencode Toggle";
        }
      ];
  };
}
