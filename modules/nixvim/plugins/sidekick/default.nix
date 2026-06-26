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
        # sidekick.nvim documentation
        # See: https://github.com/folke/sidekick.nvim
        enable = builtins.elem "sidekick" config.khanelivim.ai.plugins;

        package = pkgs.vimPlugins.sidekick-nvim.overrideAttrs (oldAttrs: {
          patches = (oldAttrs.patches or [ ]) ++ [
            (pkgs.fetchpatch {
              url = "https://github.com/folke/sidekick.nvim/pull/322.patch";
              hash = "sha256-0B8ScG2+I0kHajjplbtSzY0yve6u7EJIn05FXvxmfTY=";
            })
          ];
        });

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

          cli.tools = {
            claude_yolo = {
              cmd = [
                "claude"
                "--dangerously-skip-permissions"
              ];
              is_proc = "\\<claude\\>";
              url = "https://github.com/anthropics/claude-code";
              resume = [ "--resume" ];
              continue = [ "--continue" ];
              format.__raw = ''
                function(text)
                  local Text = require("sidekick.text")

                  Text.transform(text, function(str)
                    return str:find("[^%w/_%.%-]") and ('"' .. str .. '"') or str
                  end, "SidekickLocFile")

                  local ret = Text.to_string(text)
                  ret = ret:gsub("@([^@]-) :L(%d+)%-L(%d+)", "@%1#L%2-%3")

                  return ret
                end
              '';
            };

            codex_yolo = {
              cmd = [
                "codex"
                "--dangerously-bypass-approvals-and-sandbox"
              ];
              is_proc = "\\<codex\\>";
              url = "https://github.com/openai/codex";
              resume = [ "resume" ];
              continue = [
                "resume"
                "--last"
              ];
            };

            copilot_yolo = {
              cmd = [
                "copilot"
                "--banner"
                "--yolo"
              ];
              is_proc.__raw = ''
                function(_, proc)
                  local re = vim.regex("\\<copilot\\>")
                  return re:match_str(proc.cmd) and not proc.cmd:find("language%-server") or false
                end
              '';
              url = "https://github.com/github/copilot-cli";
              resume = [ "--resume" ];
              continue = [ "--continue" ];
            };

            antigravity_yolo = {
              cmd = [
                "agy"
                "--dangerously-skip-permissions"
              ];
              is_proc = "\\<agy\\>";
              url = "https://antigravity.google/docs/cli-overview";
              resume = [ "--continue" ];
              continue = [ "--continue" ];
              format.__raw = ''
                function(text)
                  require("sidekick.text").transform(text, function(str)
                    return str:find("[^%w/_%.%-]") and ('"' .. str .. '"') or str
                  end, "SidekickLocFile")
                end
              '';
            };

            opencode_yolo = {
              cmd = [
                "opencode"
                "run"
                "--interactive"
                "--dangerously-skip-permissions"
              ];
              env = {
                OPENCODE_THEME = "system";
              };
              keys = {
                prompt = [
                  "<a-p>"
                  "prompt"
                ];
              };
              is_proc = "\\<opencode\\>";
              url = "https://github.com/sst/opencode";
              continue = [ "--continue" ];
              native_scroll = true;
            };

            pi_yolo = {
              cmd = [ "pi" ];
              is_proc = "\\<pi\\>";
              url = "https://github.com/badlogic/pi-mono";
              resume = [ "--resume" ];
              continue = [ "--continue" ];
              native_scroll = false;
            };
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
        {
          __unkeyed-1 = "<leader>asy";
          group = "Sidekick YOLO";
          icon = "󰐃";
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

            local yolo = function(mode, key, provider, binary, desc)
              map(mode, key, provider .. "_yolo", binary, desc)
            end

            map({ "n", "v" }, "<leader>asc", "claude", "claude", "Claude Toggle")
            map({ "n", "v" }, "<leader>asC", "copilot", "copilot", "Copilot Toggle")
            map({ "n", "v" }, "<leader>asa", "antigravity", "agy", "Antigravity Toggle")
            map({ "n", "v" }, "<leader>aso", "opencode", "opencode", "Opencode Toggle")
            map({ "n", "v" }, "<leader>asx", "codex", "codex", "Codex Toggle")
            map({ "n", "v" }, "<leader>asp", "pi", "pi", "PI Coding Agent Toggle")

            yolo({ "n", "v" }, "<leader>asyc", "claude", "claude", "Claude YOLO Toggle")
            yolo({ "n", "v" }, "<leader>asyC", "copilot", "copilot", "Copilot YOLO Toggle")
            yolo({ "n", "v" }, "<leader>asya", "antigravity", "agy", "Antigravity YOLO Toggle")
            yolo({ "n", "v" }, "<leader>asyo", "opencode", "opencode", "Opencode YOLO Toggle")
            yolo({ "n", "v" }, "<leader>asyx", "codex", "codex", "Codex YOLO Toggle")
            yolo({ "n", "v" }, "<leader>asyp", "pi", "pi", "PI Coding Agent Toggle")
          end
        '';
      }
    ];
  };
}
