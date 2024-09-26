{ config, lib, ... }:
{
  plugins.bufferline =
    let
      mouse = {
        right = # Lua
          "'vertical sbuffer %d'";
        close = # Lua
          ''
            function(bufnum)
              require("mini.bufremove").delete(bufnum)
            end
          '';
      };
    in
    {
      enable = true;

      settings = {
        options = {
          mode = "buffers";
          always_show_bufferline = true;
          buffer_close_icon = "󰅖";
          close_command.__raw = mouse.close;
          close_icon = "";
          diagnostics = "nvim_lsp";
          diagnostics_indicator = # Lua
            ''
              function(count, level, diagnostics_dict, context)
                local s = ""
                for e, n in pairs(diagnostics_dict) do
                  local sym = e == "error" and " "
                    or (e == "warning" and " " or "" )
                  if(sym ~= "") then
                    s = s .. " " .. n .. sym
                  end
                end
                return s
              end
            '';
          # Will make sure all names in bufferline are unique
          enforce_regular_tabs = false;

          groups = {
            options = {
              toggle_hidden_on_enter = true;
            };

            items = [
              {
                name = "Tests";
                highlight = {
                  underline = true;
                  fg = "#a6da95";
                  sp = "#494d64";
                };
                priority = 2;
                # icon = "";
                matcher.__raw = ''
                  function(buf)
                    return buf.name:match('%test') or buf.name:match('%.spec')
                  end
                '';
              }
              {
                name = "Docs";
                highlight = {
                  undercurl = true;
                  fg = "#ffffff";
                  sp = "#494d64";
                };
                auto_close = false;
                matcher.__raw = ''
                  function(buf)
                    return buf.name:match('%.md') or buf.name:match('%.txt')
                  end
                '';
              }
            ];
          };

          indicator = {
            style = "icon";
            icon = "▎";
          };

          left_trunc_marker = "";
          max_name_length = 18;
          max_prefix_length = 15;
          modified_icon = "●";

          numbers.__raw = ''
            function(opts)
              return string.format('%s·%s', opts.raise(opts.id), opts.lower(opts.ordinal))
            end
          '';

          persist_buffer_sort = true;
          right_mouse_command.__raw = mouse.right;
          right_trunc_marker = "";
          separator_style = "slant";
          show_buffer_close_icons = true;
          show_buffer_icons = true;
          show_close_icon = true;
          show_tab_indicators = true;
          sort_by = "extension";
          tab_size = 18;

          offsets = [
            {
              filetype = "neo-tree";
              text = "File Explorer";
              text_align = "center";
              highlight = "Directory";
            }
          ];
        };
      };
    };

  keymaps = lib.mkIf config.plugins.bufferline.enable [
    {
      mode = "n";
      key = "<leader>bP";
      action = "<cmd>BufferLineTogglePin<cr>";
      options = {
        desc = "Pin buffer toggle";
      };
    }
    {
      mode = "n";
      key = "<leader>bp";
      action = "<cmd>BufferLinePick<cr>";
      options = {
        desc = "Pick Buffer";
      };
    }
    {
      mode = "n";
      key = "<leader>bsd";
      action = "<cmd>BufferLineSortByDirectory<cr>";
      options = {
        desc = "Sort By Directory";
      };
    }
    {
      mode = "n";
      key = "<leader>bse";
      action = "<cmd>BufferLineSortByExtension<cr>";
      options = {
        desc = "Sort By Extension";
      };
    }
    {
      mode = "n";
      key = "<leader>bsr";
      action = "<cmd>BufferLineSortByRelativeDirectory<cr>";
      options = {
        desc = "Sort By Relative Directory";
      };
    }
  ];
}
