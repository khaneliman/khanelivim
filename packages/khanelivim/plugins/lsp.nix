{
  config,
  lib,
  pkgs,
  self,
  ...
}:
{
  extraConfigLuaPre = ''
    local function preview_location_callback(_, result)
      if result == nil or vim.tbl_isempty(result) then
        vim.notify('No location found to preview')
        return nil
      end
    local buf, _ = vim.lsp.util.preview_location(result[1])
      if buf then
        local cur_buf = vim.api.nvim_get_current_buf()
        vim.bo[buf].filetype = vim.bo[cur_buf].filetype
      end
    end

    function peek_definition()
      local params = vim.lsp.util.make_position_params()
      return vim.lsp.buf_request(0, 'textDocument/definition', params, preview_location_callback)
    end

    local function peek_type_definition()
      local params = vim.lsp.util.make_position_params()
      return vim.lsp.buf_request(0, 'textDocument/typeDefinition', params, preview_location_callback)
    end

    require('lspconfig.ui.windows').default_options = {
      border = "rounded"
    }
  '';

  autoCmd = [
    (lib.mkIf config.plugins.lsp.servers.helm_ls.enable {
      event = "FileType";
      pattern = "helm";
      command = "LspRestart";
    })
  ];

  plugins = {
    helm = {
      inherit (config.plugins.lsp) enable;
    };
    lsp-format.enable = !config.plugins.conform-nvim.enable && config.plugins.lsp.enable;
    lsp-lines = {
      inherit (config.plugins.lsp) enable;
    };
    lsp-signature = {
      inherit (config.plugins.lsp) enable;
    };

    lsp = {
      enable = true;

      keymaps = {
        silent = true;
        diagnostic = {
          # Navigate in diagnostics
          "<leader>l[" = "goto_prev";
          "<leader>l]" = "goto_next";
          # TODO: fix theme of float
          "<leader>lH" = "open_float";
        };

        extra = [
          {
            action.__raw = ''
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
          {
            action.__raw = "peek_definition";
            mode = "n";
            key = "<leader>lp";
            options = {
              desc = "Preview definition";
            };
          }
          {
            action.__raw = "peek_type_definition";
            mode = "n";
            key = "<leader>lP";
            options = {
              desc = "Preview type definition";
            };
          }
        ];

        lspBuf = {
          "<leader>la" = "code_action";
          "<leader>ld" = "definition";
          "<leader>lD" = "references";
          "<leader>lf" = "format";
          "<leader>lh" = "hover";
          "<leader>li" = "implementation";
          "<leader>lr" = "rename";
          "<leader>lt" = "type_definition";
        };
      };

      servers = {
        bashls = {
          enable = true;
        };

        biome = {
          enable = true;
        };

        ccls = {
          enable = true;

          initOptions.compilationDatabaseDirectory = "build";
        };

        # TODO: see what further configuration might be needed
        cmake = {
          enable = true;
        };

        clangd = {
          enable = true;
        };

        csharp_ls = {
          enable = true;
        };

        cssls = {
          enable = true;
        };

        dockerls = {
          enable = true;
        };

        eslint = {
          enable = true;
        };

        # TODO: package fish-lsp
        # fish_lsp = {
        #   enable = true;
        # };

        fsautocomplete = {
          enable = true;
        };

        fsharp_language_server = {
          enable = false;
          # TODO: package FSharpLanguageServer
          # cmd = [ "${pkgs.fsharp-language-server}/FSharpLanguageServer.dll" ];
        };

        gdscript = {
          enable = true;
          package = pkgs.gdtoolkit_4;
        };

        harper_ls = {
          enable = true;
          settings = {
            "harper-ls" = {
              linters = {
                linking_verbs = true;
                wrong_quotes = true;
              };
              codeActions = {
                forceStable = true;
              };
            };
          };
        };

        helm_ls = {
          enable = true;
        };

        html = {
          enable = true;
        };

        java_language_server = {
          enable = !config.plugins.nvim-jdtls.enable;
        };

        jdtls = {
          enable = !config.plugins.nvim-jdtls.enable;
        };

        jsonls = {
          enable = true;
        };

        lua_ls = {
          enable = true;
        };

        marksman = {
          enable = true;
        };

        nil_ls = {
          enable = !config.plugins.lsp.servers.nixd.enable;
          settings = {
            formatting = {
              command = [ "${lib.getExe pkgs.nixfmt-rfc-style}" ];
            };
            nix = {
              flake = {
                autoArchive = true;
              };
            };
          };
        };

        nixd = {
          enable = true;
          settings =
            let
              flake = ''(builtins.getFlake "${self}")'';
              system = ''''${builtins.currentSystem}'';
            in
            {
              nixpkgs.expr = "import ${flake}.inputs.nixpkgs { }";
              formatting = {
                command = [ "${lib.getExe pkgs.nixfmt-rfc-style}" ];
              };
              options = {
                nixvim.expr = ''${flake}.packages.${system}.nvim.options'';
                # NOTE: These will be passed in from outside using `.extend` from the flake installing this package
                # nix-darwin.expr = ''${flake}.darwinConfigurations.khanelimac.options'';
                # nixos.expr = ''${flake}.nixosConfigurations.khanelinix.options'';
                # home-manager.expr = ''${nixos.expr}.home-manager.users.type.getSubOptions [ ]'';
              };
            };
        };

        nushell = {
          enable = true;
        };

        pyright = {
          enable = true;
        };

        ruff = {
          enable = true;
        };

        rust_analyzer = {
          enable = !config.plugins.rustaceanvim.enable;
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
        };

        statix = {
          enable = true;
          cmd = [
            "statix"
            "check"
            "-s"
          ];
        };

        stylelint_lsp = {
          enable = true;
        };

        # tailwindcss = {
        #   enable = true;
        # };

        taplo = {
          enable = true;
        };

        ts_ls = {
          enable = !config.plugins.typescript-tools.enable;
        };

        typos_lsp = {
          enable = true;
          extraOptions = {
            init_options = {
              diagnosticSeverity = "Hint";
            };
          };
        };

        yamlls = {
          enable = true;
        };
      };
    };

    which-key.settings.spec = [
      {
        __unkeyed = "<leader>l";
        group = "LSP";
        icon = " ";
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
        __unkeyed = "<leader>l[";
        desc = "Prev";
      }
      {
        __unkeyed = "<leader>l]";
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
        desc = "Lsp Hover";
      }
      {
        __unkeyed = "<leader>lH";
        desc = "Diagnostic Hover";
      }
      {
        __unkeyed = "<leader>lr";
        desc = "Rename";
      }
    ];
  };
}
