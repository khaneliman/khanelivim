{
  config,
  lib,
  pkgs,
  ...
}:
let
  # Function to recursively read all files in a directory
  readAllFiles =
    dir:
    let
      entries = builtins.attrNames (builtins.readDir dir);
      files = builtins.filter (entry: entry != "default.nix") entries;
    in
    builtins.concatMap (
      entry:
      let
        path = "${dir}/${entry}";
      in
      if builtins.pathExists path && lib.pathIsDirectory path then readAllFiles path else [ path ]
    ) files;
in
{
  imports = readAllFiles ./lsp;

  # TODO: migrate to mkneovimplugin
  extraConfigLuaPre = ''
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
      inlayHints = true;

      keymaps = {
        silent = true;
        diagnostic = {
          # Navigate in diagnostics
          "<leader>l[" = "goto_prev";
          "<leader>l]" = "goto_next";
          "<leader>lH" = "open_float";
        };

        extra =
          [
            {
              action.__raw = ''vim.lsp.buf.format'';
              mode = "v";
              key = "<leader>lf";
              options = {
                silent = true;
                buffer = false;
                desc = "Format selection";
              };
            }
          ]
          ++ lib.optionals (!config.plugins.glance.enable) [
            {
              action = "<CMD>PeekDefinition textDocument/definition<CR>";
              mode = "n";
              key = "<leader>lp";
              options = {
                desc = "Preview definition";
              };
            }
            {
              action = "<CMD>PeekDefinition textDocument/typeDefinition<CR>";
              mode = "n";
              key = "<leader>lP";
              options = {
                desc = "Preview type definition";
              };
            }
          ];

        lspBuf = {
          "<leader>ld" = "definition";
          "<leader>lD" = "references";
          "<leader>lf" = "format";
          "<leader>lh" = "hover";
          "<leader>li" = "implementation";
          "<leader>lr" = "rename";
          "<leader>lt" = "type_definition";
        } // lib.optionalAttrs (!config.plugins.fzf-lua.enable) { "<leader>la" = "code_action"; };
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

        cmake = {
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

        fish_lsp = {
          enable = true;
        };

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

        tailwindcss = {
          enable = true;
        };

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
