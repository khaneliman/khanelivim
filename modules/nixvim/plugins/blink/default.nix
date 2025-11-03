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
            columns = [
              {
                __unkeyed-1 = "label";
              }
              {
                __unkeyed-1 = "kind_icon";
                __unkeyed-2 = "kind";
                gap = 1;
              }
              {
                __unkeyed-1 = "source_name";
                gap = 1;
              }
            ];
            components = {
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
}
