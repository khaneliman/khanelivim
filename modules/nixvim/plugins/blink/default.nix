{
  config,
  lib,
  ...
}:
{
  imports = [
    ./community-plugins.nix
    ./packages.nix
    ./sources.nix
  ];

  plugins.blink-cmp = {
    enable = config.khanelivim.completion.tool == "blink";

    lazyLoad.settings.event = [
      "InsertEnter"
      "CmdlineEnter"
    ];

    settings = {
      cmdline = {
        completion = {
          list.selection = {
            preselect = false;
          };
          menu.auto_show = true;
        };
        keymap = {
          preset = "enter";
          "<CR>" = [
            "accept_and_enter"
            "fallback"
          ];
        };
      };

      completion = {
        keyword = {
          range = "full";
        };

        trigger = {
          prefetch_on_insert = true;
          show_on_backspace = true;
          # Disabled: Prefer manual completion control with <C-.>
          # Uncomment to auto-show after typing these characters:
          # show_on_x_blocked_trigger_characters = [
          #   " "
          #   ";"
          # ];
        };

        ghost_text.enabled = true;

        accept.auto_brackets = {
          override_brackets_for_filetypes = {
            lua = [
              "{"
              "}"
            ];
            nix = [
              "{"
              "}"
            ];
          };
        };

        documentation = {
          auto_show = true;
          auto_show_delay_ms = 200;
          window.border = "rounded";
        };

        list.selection = {
          auto_insert = false;
          preselect = false;
        };

        menu = {
          border = "rounded";
          draw = {
            snippet_indicator = "◦";
            treesitter = [ "lsp" ];
            columns.__raw = ''
              function()
                if vim.g.blink_show_item_idx == nil then vim.g.blink_show_item_idx = true end

                if vim.g.blink_show_item_idx then
                  return {
                    { "item_idx" },
                    { "label" },
                    { "kind_icon", "kind", gap = 1 },
                    { "source_name", gap = 1 }
                  }
                else
                  return {
                    { "label" },
                    { "kind_icon", "kind", gap = 1 },
                    { "source_name", gap = 1 }
                  }
                end
              end
            '';
            components = {
              item_idx = {
                text.__raw = ''
                  function(ctx)
                    return ctx.idx == 10 and '0' or ctx.idx >= 10 and ' ' or tostring(ctx.idx)
                  end
                '';
                highlight = "BlinkCmpItemIdx";
              };
              kind_icon = {
                ellipsis = false;
                text.__raw = ''
                  function(ctx)
                    local kind_icon, _, _ = require('mini.icons').get('lsp', ctx.kind)
                    -- Check for both nil and the default fallback icon
                    if not kind_icon or kind_icon == '󰞋' then
                      -- Use our configured kind_icons
                      return require('blink.cmp.config').appearance.kind_icons[ctx.kind] or ""
                    end
                    return kind_icon
                  end,
                  -- Optionally, you may also use the highlights from mini.icons
                  highlight = function(ctx)
                    local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
                    return hl
                  end
                '';
              };
            };
          };
        };
      };

      fuzzy = {
        implementation = "rust";
        sorts = [
          "exact"
          "score"
          "sort_text"
        ];
        prebuilt_binaries = {
          download = false;
        };
      };

      appearance = {
        # use_nvim_cmp_as_default = true;
        kind_icons = {
          Copilot = "";

          Text = "";
          Field = "";
          Variable = "";

          Class = "";
          Interface = "";

          TypeParameter = "";
        };
      };

      keymap = {
        preset = "enter";
        "<C-.>" = [
          "show"
          "show_documentation"
          "hide_documentation"
        ];
        "<A-1>" = [ { __raw = "function(cmp) cmp.accept({ index = 1 }) end"; } ];
        "<A-2>" = [ { __raw = "function(cmp) cmp.accept({ index = 2 }) end"; } ];
        "<A-3>" = [ { __raw = "function(cmp) cmp.accept({ index = 3 }) end"; } ];
        "<A-4>" = [ { __raw = "function(cmp) cmp.accept({ index = 4 }) end"; } ];
        "<A-5>" = [ { __raw = "function(cmp) cmp.accept({ index = 5 }) end"; } ];
        "<A-6>" = [ { __raw = "function(cmp) cmp.accept({ index = 6 }) end"; } ];
        "<A-7>" = [ { __raw = "function(cmp) cmp.accept({ index = 7 }) end"; } ];
        "<A-8>" = [ { __raw = "function(cmp) cmp.accept({ index = 8 }) end"; } ];
        "<A-9>" = [ { __raw = "function(cmp) cmp.accept({ index = 9 }) end"; } ];
        "<A-0>" = [ { __raw = "function(cmp) cmp.accept({ index = 10 }) end"; } ];
        "<C-y>" =
          lib.optionals config.plugins.sidekick.enable [
            {
              __raw = ''
                function()
                  return require("sidekick").nes_jump_or_apply()
                end
              '';
            }
          ]
          ++ lib.optionals config.plugins.copilot-lua.enable [
            {
              __raw = ''
                function(cmp)
                  if vim.b[vim.api.nvim_get_current_buf()].nes_state then
                    cmp.hide()
                    return (
                      require("copilot-lsp.nes").apply_pending_nes()
                      and require("copilot-lsp.nes").walk_cursor_end_edit()
                    )
                  end
                  if cmp.snippet_active() then
                    return cmp.accept()
                  else
                    return cmp.select_and_accept()
                  end
                end
              '';
            }
          ]
          ++ [ "fallback" ];

        # NOTE: If you prefer Tab/S-Tab selection
        # But, find myself accidentally interrupting tabbing for movement
        # "<A-Tab>" = [
        #   "snippet_forward"
        #   "fallback"
        # ];
        # "<A-S-Tab>" = [
        #   "snippet_backward"
        #   "fallback"
        # ];
        # "<Tab>" = [
        #   "select_next"
        #   "fallback"
        # ];
        # "<S-Tab>" = [
        #   "select_prev"
        #   "fallback"
        # ];
      };

      signature = {
        enabled = true;
        window.border = "rounded";
      };

      snippets.preset = "mini_snippets";
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>uci";
      action.__raw = ''
        function()
          vim.g.blink_show_item_idx = not vim.g.blink_show_item_idx
          vim.notify(string.format("Completion Item Index %s", bool2str(vim.g.blink_show_item_idx), "info"))
        end
      '';
      options.desc = "Completion Item Index toggle";
    }
    {
      mode = "n";
      key = "<leader>ucp";
      action.__raw = ''
        function()
          vim.g.blink_path_from_cwd = not vim.g.blink_path_from_cwd
          vim.notify(string.format("Path Completion from CWD %s", bool2str(vim.g.blink_path_from_cwd), "info"))
        end
      '';
      options.desc = "Path Completion from CWD toggle";
    }
  ];
}
