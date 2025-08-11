{ config, lib, ... }:
{
  plugins = {

    faster = {
      enable = true;

      # Lazy loading configuration
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
              "illuminate"
              "matchparen"
              "lsp"
              "treesitter"
              "indent_blankline"
              "vimopts"
              "syntax"
              "filetype"
            ];
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

          # Fast macro behavior - disable features during macro execution
          fastmacro = {
            on = true;
            features_disabled = [
              "lualine"
              "illuminate"
              "indent_blankline"
            ];
          };
        };

        features = {
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
  keymaps = lib.optionals config.plugins.faster.enable [
    # Global feature control
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

    # Behavior control
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
