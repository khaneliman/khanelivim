{ config, lib, ... }:
{
  plugins = {
    noice = {
      enable =
        config.khanelivim.ui.commandline == "noice" || config.khanelivim.ui.notifications == "noice";

      lazyLoad.settings.event = "DeferredUIEnter";

      settings = {
        # Hides the title above noice boxes
        cmdline = {
          format = {
            cmdline = {
              pattern = "^:";
              icon = "";
              lang = "vim";
              opts = {
                border = {
                  text = {
                    top = "Cmd";
                  };
                };
              };
            };
            search_down = {
              kind = "search";
              pattern = "^/";
              icon = " ";
              lang = "regex";
            };
            search_up = {
              kind = "search";
              pattern = "^%?";
              icon = " ";
              lang = "regex";
            };
            filter = {
              pattern = "^:%s*!";
              icon = "";
              lang = "bash";
              opts = {
                border = {
                  text = {
                    top = "Bash";
                  };
                };
              };
            };
            lua = {
              pattern = "^:%s*lua%s+";
              icon = "";
              lang = "lua";
            };
            help = {
              pattern = "^:%s*he?l?p?%s+";
              icon = "󰋖";
            };
            input = { };
          };
        };

        messages = lib.mkIf (config.khanelivim.ui.notifications == "noice") {
          view = "notify";
          view_error = "notify";
          view_warn = "notify";
        };

        lsp = {
          override = {
            "vim.lsp.util.convert_input_to_markdown_lines" = true;
            "vim.lsp.util.stylize_markdown" = true;
            "cmp.entry.get_documentation" = true;
          };

          progress.enabled = true;
          signature.enabled = !config.plugins.lsp-signature.enable;
        };

        popupmenu.backend = "nui";
        # Doesn't support the standard cmdline completions
        # popupmenu.backend = "cmp";

        presets = {
          bottom_search = false;
          command_palette = true;
          long_message_to_split = true;
          inc_rename = true;
          lsp_doc_border = true;
        };

        routes = [
          # Skip search_count messages
          {
            filter = {
              event = "msg_show";
              kind = "search_count";
            };
            opts = {
              skip = true;
            };
          }
          # Skip noisy LSP progress messages
          {
            filter = {
              event = "lsp";
              kind = "progress";
              cond.__raw = ''
                function(message)
                  local client = vim.tbl_get(message.opts, 'progress', 'client')
                  local servers = { 'jdtls' }

                  for index, value in ipairs(servers) do
                      if value == client then
                          return true
                      end
                  end
                end
              '';
            };
            opts = {
              skip = true;
            };
          }
          # Skip annoying "written" messages
          {
            filter = {
              event = "msg_show";
              find = "written";
            };
            opts = {
              skip = true;
            };
          }
          # Skip "search hit BOTTOM/TOP" messages
          {
            filter = {
              event = "msg_show";
              any = [
                { find = "search hit BOTTOM"; }
                { find = "search hit TOP"; }
              ];
            };
            opts = {
              skip = true;
            };
          }
          # Skip "Pattern not found" messages
          {
            filter = {
              event = "msg_show";
              find = "Pattern not found";
            };
            opts = {
              skip = true;
            };
          }
          # Route long messages (>20 lines) to split
          {
            filter = {
              event = "msg_show";
              min_height = 20;
            };
            view = "split";
            opts = {
              enter = true;
            };
          }
        ];

        views = {
          cmdline_popup = {
            border = {
              style = "single";
            };
          };

          confirm = {
            border = {
              style = "single";
              text = {
                top = "";
              };
            };
          };

          notify = lib.mkIf (config.khanelivim.ui.notifications == "noice") {
            border = {
              style = "rounded";
            };
            position = {
              row = 2;
              col = "100%";
            };
            size = {
              width = "auto";
              max_width = 60;
            };
          };
        };
      };
    };

    notify = {
      enable = true;
      lazyLoad.settings.event = "DeferredUIEnter";
    };
  };

  keymaps =
    lib.optionals (config.plugins.noice.enable && config.khanelivim.ui.notifications == "noice") [
      {
        mode = "n";
        key = "<leader>fn";
        action =
          if config.khanelivim.picker.tool == "snacks" then
            "<cmd>Noice snacks<CR>"
          else if config.khanelivim.picker.tool == "fzf" then
            "<cmd>Noice fzf<CR>"
          else if config.khanelivim.picker.tool == "telescope" then
            "<cmd>Telescope noice<CR>"
          else
            "<cmd>Noice<CR>"; # Fallback to basic Noice command
        options = {
          desc = "Find notifications";
        };
      }
    ]
    ++ lib.optionals config.plugins.noice.enable [
      # Command redirection with Shift-Enter
      {
        mode = "c";
        key = "<S-Enter>";
        action.__raw = ''
          function()
            require("noice").redirect(vim.fn.getcmdline())
          end
        '';
        options = {
          desc = "Redirect Cmdline to Popup";
        };
      }
    ];
}
