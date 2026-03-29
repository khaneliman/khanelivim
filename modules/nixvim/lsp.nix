{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    # keep-sorted start
    ./lsp/ccls.nix
    ./lsp/clangd.nix
    ./lsp/harper-ls.nix
    ./lsp/helm-ls.nix
    ./lsp/lspconfig.nix
    ./lsp/nil-ls.nix
    ./lsp/nixd.nix
    ./lsp/rust-analyzer.nix
    ./lsp/typos-lsp.nix
    # keep-sorted end
  ];

  lsp = {
    inlayHints.enable = true;

    servers = {
      "*" = {
        config = {
          capabilities = {
            textDocument = {
              semanticTokens = {
                multilineTokenSupport = true;
              };
            };
          };
        };
      };
      angularls = {
        enable = true;
        config = {
          # Upstream root detection is fine once we stop forcing `.git` on
          # every server, but Angular LS should still require a real workspace.
          workspace_required = true;
          # Upstream includes `typescriptreact`, which lets angularls attach in
          # React workspaces. Keep the Angular-relevant filetypes only.
          filetypes = [
            "typescript"
            "html"
            "htmlangular"
          ];
        };
      };
      bashls.enable = true;
      biome = {
        enable = true;
        config.filetypes = [
          "javascript"
          "javascriptreact"
          "typescript"
          "typescriptreact"
          "json"
          "jsonc"
          "css"
          "html"
        ];
      };
      cmake.enable = true;
      copilot.enable = !config.plugins.copilot-lua.enable;
      cssls.enable = true;
      dockerls.enable = lib.elem "dockerls" config.khanelivim.lsp.docker;
      docker_language_server.enable = lib.elem "docker-language-server" config.khanelivim.lsp.docker;
      # FIXME: [lspconfig] Unable to find ESLint library.
      # eslint.enable = true;
      emmylua_ls.enable = config.khanelivim.lsp.lua == "emmylua-ls";
      lua_ls.enable = config.khanelivim.lsp.lua == "lua-ls";
      fish_lsp.enable = true;
      fsautocomplete.enable = true;
      fsharp_language_server = {
        enable = false;
        # TODO: package FSharpLanguageServer
        # cmd = [ "${pkgs.fsharp-language-server}/FSharpLanguageServer.dll" ];
      };
      gdscript = {
        enable = true;
        package = pkgs.gdtoolkit_4;
      };
      gopls.enable = true;
      html.enable = true;
      hyprls.enable = true;
      java_language_server.enable = config.khanelivim.lsp.java == "java-language-server";
      jsonls.enable = true;
      kulala_ls.enable = true;
      marksman.enable = true;
      # FIXME: broken darwin
      nushell.enable = pkgs.stdenv.hostPlatform.isLinux;
      pyright.enable = config.khanelivim.lsp.python.typeChecker == "pyright";
      pylsp.enable = config.khanelivim.lsp.python.typeChecker == "pylsp";
      basedpyright.enable = config.khanelivim.lsp.python.typeChecker == "basedpyright";
      qmlls.enable = true;
      ruff.enable = lib.elem "ruff" config.khanelivim.lsp.python.linters;
      roslyn_ls.enable = config.khanelivim.lsp.csharp == "roslyn_ls";
      sqls.enable = true;
      statix.enable = true;
      stylelint_lsp = {
        enable = true;
        config = {
          # Rely on upstream stylelint root detection, but avoid attaching when
          # no stylelint workspace exists.
          workspace_required = true;
        };
      };
      tailwindcss = {
        enable = true;
        config.filetypes = [
          "css"
          "scss"
          "sass"
          "html"
          "javascriptreact"
          "typescriptreact"
          "vue"
          "svelte"
        ];
      };
      taplo.enable = true;
      ts_ls.enable = config.khanelivim.lsp.typescript == "ts_ls";
      tsgo.enable = config.khanelivim.lsp.typescript == "tsgo";
      yamlls.enable = true;
    };
  };

  autoCmd = [
    {
      event = [
        "BufWinEnter"
        "LspAttach"
      ];
      callback.__raw = ''
        function(args)
          local bufnr = args.buf
          if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then return end
          if vim.bo[bufnr].filetype == "bigfile" then return end

          local win = vim.fn.bufwinid(bufnr)
          if win == -1 then return end

          local has_lsp_folding = vim.iter(vim.lsp.get_clients({ bufnr = bufnr })):any(function(client)
            return client:supports_method("textDocument/foldingRange")
          end)

          vim.api.nvim_win_call(win, function()
            if has_lsp_folding then
              vim.wo.foldmethod = "expr"
              vim.wo.foldexpr = "v:lua.vim.lsp.foldexpr()"
            else
              vim.wo.foldmethod = "expr"
              vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
            end
          end)
        end
      '';
    }
    {
      event = "LspAttach";
      callback.__raw = ''
        function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then return end

          if client:supports_method("textDocument/linkedEditingRange") then
            vim.lsp.linked_editing_range.enable(true, { client_id = client.id })
          end

          local python_type_checkers = {
            pyright = true,
            basedpyright = true,
            pylsp = true,
          }

          if client.name == "ruff" then
            local has_python_type_checker = vim.iter(vim.lsp.get_clients({ bufnr = args.buf })):any(function(other)
              return other.id ~= client.id and python_type_checkers[other.name]
            end)

            if has_python_type_checker then
              client.server_capabilities.hoverProvider = false
            end
            return
          end

          if python_type_checkers[client.name] then
            for _, other in ipairs(vim.lsp.get_clients({ bufnr = args.buf })) do
              if other.name == "ruff" then
                other.server_capabilities.hoverProvider = false
              end
            end
          end
        end
      '';
    }
    {
      event = [
        "BufEnter"
        "CursorHold"
        "InsertLeave"
        "LspAttach"
      ];
      callback.__raw = ''
        function(args)
          local bufnr = args.buf
          if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then return end

          local supports_codelens = vim.iter(vim.lsp.get_clients({ bufnr = bufnr })):any(function(client)
            return client:supports_method("textDocument/codeLens")
          end)

          if not supports_codelens then return end
          if not vim.lsp.codelens.is_enabled({ bufnr = bufnr }) then return end

          vim.lsp.codelens.refresh({ bufnr = bufnr })
        end
      '';
    }
  ];

  keymapsOnEvents.LspAttach = [
    (lib.mkIf (!config.plugins.conform-nvim.enable) {
      action.__raw = "vim.lsp.buf.format";
      mode = "v";
      key = "<leader>lf";
      options = {
        silent = true;
        buffer = false;
        desc = "Format selection";
      };
    })
    # Diagnostic keymaps
    {
      key = "<leader>lH";
      mode = "n";
      action = lib.nixvim.mkRaw "vim.diagnostic.open_float";
      options = {
        silent = true;
        desc = "Lsp diagnostic open_float";
      };
    }
    {
      key = "<leader>l[";
      mode = "n";
      action = lib.nixvim.mkRaw ''
        function()
          vim.diagnostic.jump({
            count = -1,
          })
        end
      '';
      options = {
        silent = true;
        desc = "Previous diagnostic";
      };
    }
    {
      key = "<leader>l]";
      mode = "n";
      action = lib.nixvim.mkRaw ''
        function()
          vim.diagnostic.jump({
            count = 1,
          })
        end
      '';
      options = {
        silent = true;
        desc = "Next diagnostic";
      };
    }
    {
      key = "<leader>lI";
      mode = "n";
      action = "<cmd>checkhealth vim.lsp<CR>";
      options = {
        silent = true;
        desc = "LSP info";
      };
    }
    {
      key = "<leader>lQ";
      mode = "n";
      action = lib.nixvim.mkRaw ''
        function()
          local supports_workspace_diagnostics = vim.iter(vim.lsp.get_clients({ bufnr = 0 })):any(function(client)
            return client:supports_method("workspace/diagnostic")
          end)

          if not supports_workspace_diagnostics then
            vim.notify("No attached LSP supports workspace diagnostics", vim.log.levels.INFO)
            return
          end

          vim.lsp.buf.workspace_diagnostics()
        end
      '';
      options = {
        silent = true;
        desc = "Workspace diagnostics";
      };
    }
    {
      key = "<leader>lX";
      mode = "n";
      action = "<cmd>lsp restart<CR>";
      options = {
        silent = true;
        desc = "Restart LSP";
      };
    }
    {
      key = "<leader>lE";
      mode = "n";
      action = lib.nixvim.mkRaw ''
        function()
          local format = function(diagnostic)
            local source = diagnostic.source and string.format(" [%s]", diagnostic.source) or ""
            local code = diagnostic.code and string.format(" (%s)", diagnostic.code) or ""
            local message = diagnostic.message:gsub("%s+", " ")
            return string.format("%s%s%s", message, source, code)
          end

          vim.diagnostic.setqflist({
            open = true,
            severity = { min = vim.diagnostic.severity.WARN },
            title = "Workspace Diagnostics",
            format = format,
          })
        end
      '';
      options = {
        silent = true;
        desc = "Workspace diagnostics list";
      };
    }
    {
      key = "<leader>lW";
      mode = "n";
      action = lib.nixvim.mkRaw ''
        function()
          local format = function(diagnostic)
            local source = diagnostic.source and string.format(" [%s]", diagnostic.source) or ""
            local code = diagnostic.code and string.format(" (%s)", diagnostic.code) or ""
            local message = diagnostic.message:gsub("%s+", " ")
            return string.format("%s%s%s", message, source, code)
          end

          vim.diagnostic.setqflist({
            open = true,
            severity = { min = vim.diagnostic.severity.ERROR, max = vim.diagnostic.severity.ERROR },
            title = "Workspace Errors",
            format = format,
          })
        end
      '';
      options = {
        silent = true;
        desc = "Workspace errors list";
      };
    }
    {
      key = "<leader>lq";
      mode = "n";
      action = lib.nixvim.mkRaw ''
        function()
          local format = function(diagnostic)
            local source = diagnostic.source and string.format(" [%s]", diagnostic.source) or ""
            local code = diagnostic.code and string.format(" (%s)", diagnostic.code) or ""
            local message = diagnostic.message:gsub("%s+", " ")
            return string.format("%s%s%s", message, source, code)
          end

          vim.diagnostic.setloclist({
            open = true,
            severity = { min = vim.diagnostic.severity.WARN },
            title = "Buffer Diagnostics",
            format = format,
          })
        end
      '';
      options = {
        silent = true;
        desc = "Buffer diagnostics list";
      };
    }
    {
      key = "<leader>le";
      mode = "n";
      action = lib.nixvim.mkRaw ''
        function()
          local format = function(diagnostic)
            local source = diagnostic.source and string.format(" [%s]", diagnostic.source) or ""
            local code = diagnostic.code and string.format(" (%s)", diagnostic.code) or ""
            local message = diagnostic.message:gsub("%s+", " ")
            return string.format("%s%s%s", message, source, code)
          end

          vim.diagnostic.setloclist({
            open = true,
            severity = { min = vim.diagnostic.severity.ERROR, max = vim.diagnostic.severity.ERROR },
            title = "Buffer Errors",
            format = format,
          })
        end
      '';
      options = {
        silent = true;
        desc = "Buffer errors list";
      };
    }
    {
      key = "<leader>lx";
      mode = "n";
      action = lib.nixvim.mkRaw ''
        function()
          local supports_codelens = vim.iter(vim.lsp.get_clients({ bufnr = 0 })):any(function(client)
            return client:supports_method("textDocument/codeLens")
          end)

          if not supports_codelens then
            vim.notify("No attached LSP supports code lens", vim.log.levels.INFO)
            return
          end

          vim.lsp.codelens.run()
        end
      '';
      options = {
        silent = true;
        desc = "Run code lens";
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
  ]
  ++ lib.optionals (!config.plugins.conform-nvim.enable) [
    # Format keymap (if conform-nvim is not enabled)
    {
      key = "<leader>lf";
      mode = "n";
      action = lib.nixvim.mkRaw "vim.lsp.buf.format";
      options = {
        silent = true;
        desc = "Lsp buf format";
      };
    }
  ]
  ++
    lib.optionals
      (
        !config.plugins.fzf-lua.enable
        || (config.plugins.snacks.enable && lib.hasAttr "picker" config.plugins.snacks.settings)
      )
      [
        # Code action keymap (if fzf-lua is not enabled)
        {
          key = "<leader>la";
          mode = "n";
          action = lib.nixvim.mkRaw "vim.lsp.buf.code_action";
          options = {
            silent = true;
            desc = "Lsp buf code_action";
          };
        }
      ]
  ++
    lib.optionals
      (
        (
          !config.plugins.snacks.enable
          || (config.plugins.snacks.enable && !lib.hasAttr "picker" config.plugins.snacks.settings)
        )
        && !config.plugins.fzf-lua.enable
        && !config.plugins.glance.enable
      )
      [
        # Definition and type_definition keymaps (conditionally)
        {
          key = "<leader>ld";
          mode = "n";
          action = lib.nixvim.mkRaw "vim.lsp.buf.definition";
          options = {
            silent = true;
            desc = "Lsp buf definition";
          };
        }
        {
          key = "<leader>lt";
          mode = "n";
          action = lib.nixvim.mkRaw "vim.lsp.buf.type_definition";
          options = {
            silent = true;
            desc = "Lsp buf type_definition";
          };
        }
      ];

  plugins = {
    lsp-format.enable = !config.plugins.conform-nvim.enable && config.plugins.lsp.enable;
    lsp-signature.enable =
      config.plugins.lsp.enable && config.khanelivim.ui.signatureHelp == "lsp-signature";

    which-key.settings.spec = [
      {
        __unkeyed-1 = "gx";
        desc = "Open Document Link";
      }
      {
        __unkeyed-1 = "<leader>l";
        group = "LSP";
        icon = " ";
        mode = [
          "n"
          "v"
        ];
      }
      {
        __unkeyed-1 = "<leader>l[";
        desc = "Prev";
      }
      {
        __unkeyed-1 = "<leader>l]";
        desc = "Next";
      }
      {
        __unkeyed-1 = "<leader>la";
        desc = "Code Action";
      }
      {
        __unkeyed-1 = "<leader>ld";
        desc = "Definition";
      }
      {
        __unkeyed-1 = "<leader>lE";
        desc = "Workspace Diagnostics List";
      }
      {
        __unkeyed-1 = "<leader>lD";
        desc = "References";
      }
      {
        __unkeyed-1 = "<leader>le";
        desc = "Buffer Errors List";
      }
      {
        __unkeyed-1 = "<leader>lf";
        desc = "Format";
      }
      {
        __unkeyed-1 = "<leader>lh";
        desc = "Lsp Hover";
      }
      {
        __unkeyed-1 = "<leader>lI";
        desc = "LSP Info";
      }
      {
        __unkeyed-1 = "<leader>lH";
        desc = "Diagnostic Hover";
      }
      {
        __unkeyed-1 = "<leader>li";
        desc = "Implementation";
      }
      {
        __unkeyed-1 = "<leader>lr";
        desc = "Rename";
      }
      {
        __unkeyed-1 = "<leader>lq";
        desc = "Buffer Diagnostics List";
      }
      {
        __unkeyed-1 = "<leader>lQ";
        desc = "Workspace Diagnostics";
      }
      {
        __unkeyed-1 = "<leader>lW";
        desc = "Workspace Errors List";
      }
      {
        __unkeyed-1 = "<leader>lt";
        desc = "Type Definition";
      }
      {
        __unkeyed-1 = "<leader>lX";
        desc = "Restart LSP";
      }
      {
        __unkeyed-1 = "<leader>lx";
        desc = "Run Code Lens";
      }
    ];
  };
}
