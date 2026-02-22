{ config, lib, ... }:
{
  plugins = {
    trouble = {
      # trouble.nvim documentation
      # See: https://github.com/folke/trouble.nvim
      enable = true;

      lazyLoad.settings.cmd = [ "Trouble" ];

      settings = {
        auto_close = true;
        modes = {
          diagnostics = {
            filter.__raw = ''
              function(items)
                return vim.tbl_filter(function(item)
                    return not string.match(item.basename, [[%__virtual.cs$]])
                end, items)
              end
            '';
          };
          preview_split = {
            # NOTE: can automatically open when diagnostics exist
            # auto_open = true;
            mode = "diagnostics";
            preview = {
              type = "split";
              relative = "win";
              position = "right";
              size = 0.5;
            };
          };

          preview_float = {
            mode = "diagnostics";
            preview = {
              type = "float";
              relative = "editor";
              border = "rounded";
              title = "Preview";
              title_pos = "center";
              position = [
                0
                (-2)
              ];
              size = {
                width = 0.3;
                height = 0.3;
              };
              zindex = 200;
            };
          };
        };
      };
    };

  };

  keymaps = lib.mkIf config.plugins.trouble.enable [
    {
      mode = "n";
      key = "<leader>xx";
      action = "<cmd>Trouble preview_split toggle<cr>";
      options = {
        desc = "Diagnostics toggle";
      };
    }
    {
      mode = "n";
      key = "<leader>xX";
      action = "<cmd>Trouble preview_split toggle filter.buf=0<cr>";
      options = {
        desc = "Buffer Diagnostics toggle";
      };
    }
    {
      mode = "n";
      key = "<leader>xs";
      action = "<cmd>Trouble symbols toggle focus=false<cr>";
      options = {
        desc = "Symbols toggle";
      };
    }
    {
      mode = "n";
      key = "<leader>xl";
      action = "<cmd>Trouble lsp toggle focus=false win.position=right<cr>";
      options = {
        desc = "LSP Definitions / references / ... toggle";
      };
    }
    {
      mode = "n";
      key = "<leader>xL";
      action = "<cmd>Trouble loclist toggle<cr>";
      options = {
        desc = "Location List toggle";
      };
    }
    {
      mode = "n";
      key = "<leader>xQ";
      action = "<cmd>Trouble qflist toggle<cr>";
      options = {
        desc = "Quickfix List toggle";
      };
    }
  ];
}
