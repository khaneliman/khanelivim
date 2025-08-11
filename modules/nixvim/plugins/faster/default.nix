{ config, lib, ... }:
{
  plugins = {

    faster = {
      enable = true;

      lazyLoad.settings = {
        event = [
          "DeferredUIEnter"
        ];
      };

      settings = {
        behaviours = {
          bigfile = {
            on = true;
            features_disabled = [
              "filetype"
              "illuminate"
              "indent_blankline"
              "lsp"
              "matchparen"
              "syntax"
              "treesitter"
              "vimopts"
            ]
            ++ lib.optionals config.plugins.bufferline.enable [ "bufferline" ]
            ++ lib.optionals config.plugins.gitsigns.enable [ "gitsigns" ]
            ++ lib.optionals config.plugins.mini.enable [ "mini_indentscope" ]
            ++ lib.optionals config.plugins.noice.enable [ "noice" ]
            ++ lib.optionals config.plugins.snacks.enable [ "snacks" ];
            filesize = 2;
            pattern = "*";
            extra_patterns = [
              # More aggressive for log files
              {
                filesize = 1;
                pattern = "*.log";
              }
              # Even more aggressive for large data files
              {
                filesize = 0.5;
                pattern = "*.{csv,json,xml}";
              }
              # Markdown files can get large with embedded content
              {
                filesize = 1.5;
                pattern = "*.md";
              }
            ];
          };

          fastmacro = {
            on = true;
            features_disabled = [
              "illuminate"
              "indent_blankline"
              "lualine"
            ]
            ++ lib.optionals config.plugins.bufferline.enable [ "bufferline" ]
            ++ lib.optionals config.plugins.mini.enable [ "mini_indentscope" ]
            ++ lib.optionals config.plugins.noice.enable [ "noice" ];
          };
        };

        features = {
          noice = {
            on = config.plugins.noice.enable;
            defer = false;
            enable.__raw = ''
              function()
                if pcall(require, "noice") then
                  require("noice").enable()
                end
              end
            '';
            disable.__raw = ''
              function()
                if pcall(require, "noice") then
                  require("noice").disable()
                end
              end
            '';
            commands.__raw = ''
              function()
                vim.api.nvim_create_user_command("FasterEnableNoice", function()
                  if pcall(require, "noice") then
                    require("noice").enable()
                  end
                end, {})
                vim.api.nvim_create_user_command("FasterDisableNoice", function()
                  if pcall(require, "noice") then
                    require("noice").disable()
                  end
                end, {})
              end
            '';
          };

          gitsigns = {
            on = config.plugins.gitsigns.enable;
            defer = false;
            enable.__raw = ''
              function()
                if pcall(require, "gitsigns") then
                  require("gitsigns").toggle_signs(true)
                  require("gitsigns").toggle_current_line_blame(true)
                end
              end
            '';
            disable.__raw = ''
              function()
                if pcall(require, "gitsigns") then
                  require("gitsigns").toggle_signs(false)
                  require("gitsigns").toggle_linehl(false)
                  require("gitsigns").toggle_word_diff(false)
                  require("gitsigns").toggle_current_line_blame(false)
                end
              end
            '';
            commands.__raw = ''
              function()
                vim.api.nvim_create_user_command("FasterEnableGitsigns", function()
                  if pcall(require, "gitsigns") then
                    require("gitsigns").toggle_signs(true)
                    require("gitsigns").toggle_current_line_blame(true)
                  end
                end, {})
                vim.api.nvim_create_user_command("FasterDisableGitsigns", function()
                  if pcall(require, "gitsigns") then
                    require("gitsigns").toggle_signs(false)
                    require("gitsigns").toggle_linehl(false)
                    require("gitsigns").toggle_word_diff(false)
                    require("gitsigns").toggle_current_line_blame(false)
                  end
                end, {})
              end
            '';
          };

          bufferline = {
            on = config.plugins.bufferline.enable;
            defer = false;
            enable.__raw = ''
              function()
                if pcall(require, "bufferline") then
                  vim.opt.showtabline = 2
                end
              end
            '';
            disable.__raw = ''
              function()
                vim.opt.showtabline = 0
              end
            '';
            commands.__raw = ''
              function()
                vim.api.nvim_create_user_command("FasterEnableBufferline", function()
                  if pcall(require, "bufferline") then
                    vim.opt.showtabline = 2
                  end
                end, {})
                vim.api.nvim_create_user_command("FasterDisableBufferline", function()
                  vim.opt.showtabline = 0
                end, {})
              end
            '';
          };

          mini_indentscope = {
            on = config.plugins.mini.enable;
            defer = false;
            enable.__raw = ''
              function()
                if pcall(require, "mini.indentscope") then
                  vim.g.miniindentscope_disable = false
                end
              end
            '';
            disable.__raw = ''
              function()
                vim.g.miniindentscope_disable = true
              end
            '';
            commands.__raw = ''
              function()
                vim.api.nvim_create_user_command("FasterEnableMiniIndentscope", function()
                  vim.g.miniindentscope_disable = false
                end, {})
                vim.api.nvim_create_user_command("FasterDisableMiniIndentscope", function()
                  vim.g.miniindentscope_disable = true
                end, {})
              end
            '';
          };

          snacks = {
            on = config.plugins.snacks.enable;
            defer = false;
            enable.__raw = ''
              function()
                if pcall(require, "snacks") then
                  local snacks = require("snacks")
                  if snacks.scroll then snacks.scroll.enable() end
                  if snacks.indent then snacks.indent.enable() end
                end
              end
            '';
            disable.__raw = ''
              function()
                if pcall(require, "snacks") then
                  local snacks = require("snacks")
                  if snacks.scroll then snacks.scroll.disable() end
                  if snacks.indent then snacks.indent.disable() end
                end
              end
            '';
            commands.__raw = ''
              function()
                vim.api.nvim_create_user_command("FasterEnableSnacks", function()
                  if pcall(require, "snacks") then
                    local snacks = require("snacks")
                    if snacks.scroll then snacks.scroll.enable() end
                    if snacks.indent then snacks.indent.enable() end
                  end
                end, {})
                vim.api.nvim_create_user_command("FasterDisableSnacks", function()
                  if pcall(require, "snacks") then
                    local snacks = require("snacks")
                    if snacks.scroll then snacks.scroll.disable() end
                    if snacks.indent then snacks.indent.disable() end
                  end
                end, {})
              end
            '';
          };
        };
      };
    };

    which-key.settings.spec = lib.optionals config.plugins.faster.enable [
      {
        __unkeyed-1 = "<leader>ux";
        group = "Faster";
        icon = "";
      }
    ];
  };

  # Keymaps for faster.nvim commands
  keymaps =
    lib.optionals config.plugins.faster.enable [
      {
        mode = "n";
        key = "<leader>uxA";
        action = "<cmd>FasterDisableAllFeatures<CR>";
        options = {
          desc = "Faster: Disable all features";
        };
      }
      {
        mode = "n";
        key = "<leader>uxa";
        action = "<cmd>FasterEnableAllFeatures<CR>";
        options = {
          desc = "Faster: Enable all features";
        };
      }
      {
        mode = "n";
        key = "<leader>uxb";
        action = "<cmd>FasterDisableBigfile<CR>";
        options = {
          desc = "Faster: Disable bigfile behavior";
        };
      }
      {
        mode = "n";
        key = "<leader>uxB";
        action = "<cmd>FasterEnableBigfile<CR>";
        options = {
          desc = "Faster: Enable bigfile behavior";
        };
      }
      {
        mode = "n";
        key = "<leader>uxm";
        action = "<cmd>FasterDisableFastmacro<CR>";
        options = {
          desc = "Faster: Disable fastmacro behavior";
        };
      }
      {
        mode = "n";
        key = "<leader>uxM";
        action = "<cmd>FasterEnableFastmacro<CR>";
        options = {
          desc = "Faster: Enable fastmacro behavior";
        };
      }

      # Individual feature toggles
      {
        mode = "n";
        key = "<leader>uxl";
        action = "<cmd>FasterDisableLsp<CR>";
        options = {
          desc = "Faster: Disable LSP";
        };
      }
      {
        mode = "n";
        key = "<leader>uxL";
        action = "<cmd>FasterEnableLsp<CR>";
        options = {
          desc = "Faster: Enable LSP";
        };
      }
      {
        mode = "n";
        key = "<leader>uxt";
        action = "<cmd>FasterDisableTreesitter<CR>";
        options = {
          desc = "Faster: Disable Treesitter";
        };
      }
      {
        mode = "n";
        key = "<leader>uxT";
        action = "<cmd>FasterEnableTreesitter<CR>";
        options = {
          desc = "Faster: Enable Treesitter";
        };
      }
      {
        mode = "n";
        key = "<leader>uxi";
        action = "<cmd>FasterDisableIlluminate<CR>";
        options = {
          desc = "Faster: Disable Illuminate";
        };
      }
      {
        mode = "n";
        key = "<leader>uxI";
        action = "<cmd>FasterEnableIlluminate<CR>";
        options = {
          desc = "Faster: Enable Illuminate";
        };
      }
      {
        mode = "n";
        key = "<leader>uxs";
        action = "<cmd>FasterDisableSyntax<CR>";
        options = {
          desc = "Faster: Disable Syntax";
        };
      }
      {
        mode = "n";
        key = "<leader>uxS";
        action = "<cmd>FasterEnableSyntax<CR>";
        options = {
          desc = "Faster: Enable Syntax";
        };
      }
      {
        mode = "n";
        key = "<leader>uxp";
        action = "<cmd>FasterDisableMatchparen<CR>";
        options = {
          desc = "Faster: Disable Matchparen";
        };
      }
      {
        mode = "n";
        key = "<leader>uxP";
        action = "<cmd>FasterEnableMatchparen<CR>";
        options = {
          desc = "Faster: Enable Matchparen";
        };
      }
      {
        mode = "n";
        key = "<leader>uxn";
        action = "<cmd>FasterDisableIndentblankline<CR>";
        options = {
          desc = "Faster: Disable Indent Blankline";
        };
      }
      {
        mode = "n";
        key = "<leader>uxN";
        action = "<cmd>FasterEnableIndentblankline<CR>";
        options = {
          desc = "Faster: Enable Indent Blankline";
        };
      }
      {
        mode = "n";
        key = "<leader>uxu";
        action = "<cmd>FasterDisableLualine<CR>";
        options = {
          desc = "Faster: Disable Lualine";
        };
      }
      {
        mode = "n";
        key = "<leader>uxU";
        action = "<cmd>FasterEnableLualine<CR>";
        options = {
          desc = "Faster: Enable Lualine";
        };
      }
      {
        mode = "n";
        key = "<leader>uxy";
        action = "<cmd>FasterDisableFiletype<CR>";
        options = {
          desc = "Faster: Disable Filetype";
        };
      }
      {
        mode = "n";
        key = "<leader>uxY";
        action = "<cmd>FasterEnableFiletype<CR>";
        options = {
          desc = "Faster: Enable Filetype";
        };
      }
      {
        mode = "n";
        key = "<leader>uxv";
        action = "<cmd>FasterDisableVimopts<CR>";
        options = {
          desc = "Faster: Disable Vim Options";
        };
      }
      {
        mode = "n";
        key = "<leader>uxV";
        action = "<cmd>FasterEnableVimopts<CR>";
        options = {
          desc = "Faster: Enable Vim Options";
        };
      }

    ]
    ++ lib.optionals config.plugins.noice.enable [
      {
        mode = "n";
        key = "<leader>uxo";
        action = "<cmd>FasterDisableNoice<CR>";
        options = {
          desc = "Faster: Disable Noice";
        };
      }
      {
        mode = "n";
        key = "<leader>uxO";
        action = "<cmd>FasterEnableNoice<CR>";
        options = {
          desc = "Faster: Enable Noice";
        };
      }
    ]
    ++ lib.optionals config.plugins.gitsigns.enable [
      {
        mode = "n";
        key = "<leader>uxg";
        action = "<cmd>FasterDisableGitsigns<CR>";
        options = {
          desc = "Faster: Disable Gitsigns";
        };
      }
      {
        mode = "n";
        key = "<leader>uxG";
        action = "<cmd>FasterEnableGitsigns<CR>";
        options = {
          desc = "Faster: Enable Gitsigns";
        };
      }
    ]
    ++ lib.optionals config.plugins.bufferline.enable [
      {
        mode = "n";
        key = "<leader>uxr";
        action = "<cmd>FasterDisableBufferline<CR>";
        options = {
          desc = "Faster: Disable Bufferline";
        };
      }
      {
        mode = "n";
        key = "<leader>uxR";
        action = "<cmd>FasterEnableBufferline<CR>";
        options = {
          desc = "Faster: Enable Bufferline";
        };
      }
    ]
    ++ lib.optionals config.plugins.mini.enable [
      {
        mode = "n";
        key = "<leader>uxd";
        action = "<cmd>FasterDisableMiniIndentscope<CR>";
        options = {
          desc = "Faster: Disable Mini Indentscope";
        };
      }
      {
        mode = "n";
        key = "<leader>uxD";
        action = "<cmd>FasterEnableMiniIndentscope<CR>";
        options = {
          desc = "Faster: Enable Mini Indentscope";
        };
      }
    ]
    ++ lib.optionals config.plugins.snacks.enable [
      {
        mode = "n";
        key = "<leader>uxk";
        action = "<cmd>FasterDisableSnacks<CR>";
        options = {
          desc = "Faster: Disable Snacks";
        };
      }
      {
        mode = "n";
        key = "<leader>uxK";
        action = "<cmd>FasterEnableSnacks<CR>";
        options = {
          desc = "Faster: Enable Snacks";
        };
      }
    ]
    ++ [
      # Configuration inspection
      {
        mode = "n";
        key = "<leader>uxc";
        action = "<cmd>FasterPrintConfig<CR>";
        options = {
          desc = "Faster: Print current configuration";
        };
      }
    ];
}
