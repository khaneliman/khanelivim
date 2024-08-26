{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) getExe mkIf;
in
{
  extraConfigLuaPre = # Lua
    ''
      vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticError", linehl = "", numhl = "" })
      vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticWarn", linehl = "", numhl = "" })
      vim.fn.sign_define("DiagnosticSignHint", { text = " 󰌵", texthl = "DiagnosticHint", linehl = "", numhl = "" })
      vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticInfo", linehl = "", numhl = "" })
    '';

  plugins = {
    lspkind.enable = true;
    lsp-lines.enable = true;
    lsp-format.enable = mkIf (!config.plugins.conform-nvim.enable) true;

    # TODO: set up autocmd to reconfigure data with each project
    nvim-jdtls = {
      enable = true;
      configuration = "$XDG_CACHE_HOME/jdtls/config";
      data = "$XDG_CACHE_HOME/jdtls/workspace";
    };

    lsp = {
      enable = true;

      keymaps = {
        silent = true;
        diagnostic = {
          # Navigate in diagnostics
          "<leader>lp" = "goto_prev";
          "<leader>ln" = "goto_next";
        };

        extra = [
          {
            action.__raw = # Lua
              ''
                function()
                  vim.lsp.buf.format({
                    async = true,
                    range = {
                      ["start"] = vim.api.nvim_buf_get_mark(0, "<"),
                      ["end"] = vim.api.nvim_buf_get_mark(0, ">"),
                    }
                  })
                end
              '';
            mode = "v";
            key = "<leader>lf";
            options = {
              desc = "Format selection";
            };
          }
        ];

        lspBuf = {
          "<leader>la" = "code_action";
          "<leader>ld" = "definition";
          "<leader>lf" = "format";
          "<leader>lD" = "references";
          "<leader>lt" = "type_definition";
          "<leader>li" = "implementation";
          "<leader>lh" = "hover";
          "<leader>lr" = "rename";
        };
      };

      servers = {
        bashls = {
          enable = true;

          filetypes = [
            "sh"
            "bash"
          ];
        };

        ccls = {
          enable = true;
          filetypes = [
            "c"
            "cpp"
            "objc"
            "objcpp"
          ];

          initOptions.compilationDatabaseDirectory = "build";
        };

        # TODO: see what further configuration might be needed
        cmake = {
          enable = true;
          filetypes = [ "cmake" ];
        };

        clangd = {
          enable = true;
          filetypes = [
            "c"
            "cpp"
            "objc"
            "objcpp"
          ];
        };

        csharp-ls = {
          enable = true;
          filetypes = [ "cs" ];
        };

        cssls = {
          enable = true;
          filetypes = [
            "css"
            "less"
            "scss"
          ];
        };

        dockerls = {
          enable = true;
          filetypes = [ "dockerfile" ];
        };

        eslint = {
          enable = true;
          filetypes = [
            "javascript"
            "javascriptreact"
            "typescript"
            "typescriptreact"
          ];
        };

        fsautocomplete = {
          enable = true;
          filetypes = [ "fsharp" ];
        };

        gdscript = {
          enable = true;
          filetypes = [
            "gd"
            "gdscript"
            "gdscript3"
          ];
        };

        html = {
          enable = true;
          filetypes = [ "html" ];
        };

        java-language-server = {
          enable = !config.plugins.nvim-jdtls.enable;
          filetypes = [ "java" ];
        };

        jdt-language-server = {
          inherit (config.plugins.nvim-jdtls) enable;
          filetypes = [ "java" ];
        };

        jsonls = {
          enable = true;
          filetypes = [
            "json"
            "jsonc"
          ];
        };

        lua-ls = {
          enable = true;
          filetypes = [ "lua" ];
        };

        marksman = {
          enable = true;
          filetypes = [ "markdown" ];
        };

        nil-ls = {
          enable = true;
          filetypes = [ "nix" ];
          settings = {
            formatting = {
              command = [ "${getExe pkgs.nixfmt-rfc-style}" ];
            };
            nix = {
              flake = {
                autoArchive = true;
              };
            };
          };
        };

        pyright = {
          enable = true;
          filetypes = [ "python" ];
        };

        ruff = {
          enable = true;
          filetypes = [ "python" ];
        };

        rust-analyzer = {
          enable = mkIf (!config.plugins.rustaceanvim.enable) true;
          filetypes = [ "rust" ];
          installCargo = true;
          installRustc = true;

          settings = {
            diagnostics = {
              enable = true;
              # experimental.enable = true;
              styleLints.enable = true;
            };

            files = {
              excludeDirs = [
                ".direnv"
                "rust/.direnv"
              ];
            };

            inlayHints = {
              bindingModeHints.enable = true;
              closureStyle = "rust_analyzer";
              closureReturnTypeHints.enable = "always";
              discriminantHints.enable = "always";
              expressionAdjustmentHints.enable = "always";
              implicitDrops.enable = true;
              lifetimeElisionHints.enable = "always";
              rangeExclusiveHints.enable = true;
            };

            procMacro = {
              enable = true;
            };
          };
        };

        sqls = {
          enable = true;
          filetypes = [ "sql" ];
        };

        # tailwindcss = {
        #   enable = true;
        #   filetypes = [ "css" ];
        # };

        taplo = {
          enable = true;
          filetypes = [ "toml" ];
        };

        tsserver = {
          enable = true;
          filetypes = [
            "javascript"
            "javascriptreact"
            "typescript"
            "typescriptreact"
          ];
        };

        yamlls = {
          enable = true;
          filetypes = [ "yaml" ];
        };
      };
    };

    which-key.settings.spec = [
      {
        __unkeyed = "<leader>l";
        group = "  LSP";
      }
      {
        __unkeyed = "<leader>la";
        desc = "Code Action";
      }
      {
        __unkeyed = "<leader>ld";
        desc = "Definition";
      }
      {
        __unkeyed = "<leader>lD";
        desc = "References";
      }
      {
        __unkeyed = "<leader>lf";
        desc = "Format";
      }
      {
        __unkeyed = "<leader>lp";
        desc = "Prev";
      }
      {
        __unkeyed = "<leader>ln";
        desc = "Next";
      }
      {
        __unkeyed = "<leader>lt";
        desc = "Type Definition";
      }
      {
        __unkeyed = "<leader>li";
        desc = "Implementation";
      }
      {
        __unkeyed = "<leader>lh";
        desc = "Hover";
      }
      {
        __unkeyed = "<leader>lr";
        desc = "Rename";
      }
    ];
  };
}
