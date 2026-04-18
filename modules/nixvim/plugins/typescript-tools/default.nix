{
  config,
  lib,
  pkgs,
  ...
}:
let
  typescriptToolsEnabled = config.khanelivim.lsp.typescript == "typescript-tools";
  tsserverPath = "${pkgs.typescript}/lib/node_modules/typescript/lib/tsserver.js";
in
{
  extraPackages = lib.mkIf typescriptToolsEnabled [ pkgs.typescript ];

  plugins = {
    typescript-tools = {
      # typescript-tools.nvim documentation
      # See: https://github.com/pmizio/typescript-tools.nvim
      enable = typescriptToolsEnabled;

      lazyLoad.settings.ft = [
        "typescript"
        "javascript"
        "typescriptreact"
        "javascriptreact"
      ];

      settings = {
        handlers = {
          "textDocument/publishDiagnostics".__raw = ''
            require("typescript-tools.api").filter_diagnostics({
              -- Suggestion-level diagnostic; useful in some teams, noisy in others.
              -- 80006,
            })
          '';
        };

        settings = {
          code_lens = "off";
          complete_function_calls = false;
          disable_member_code_lens = true;
          expose_as_code_action = "all";
          include_completions_with_insert_text = true;
          publish_diagnostic_on = "insert_leave";
          separate_diagnostic_server = true;
          tsserver_path = tsserverPath;
          tsserver_file_preferences = {
            # Conservative default: add the most useful hints without turning
            # every TS buffer into an annotation wall.
            # includeInlayParameterNameHints = "literals";
            includeInlayEnumMemberValueHints = true;
            includeCompletionsForModuleExports = true;
            quotePreference = "auto";

            # More complete, but noisier, inlay-hint presets to trial later:
            includeInlayParameterNameHints = "all";
            includeInlayFunctionParameterTypeHints = true;
            includeInlayVariableTypeHints = true;
            includeInlayVariableTypeHintsWhenTypeMatchesName = true;
            includeInlayPropertyDeclarationTypeHints = true;
            includeInlayFunctionLikeReturnTypeHints = true;
          };
          tsserver_plugins = [
            # These are only loaded when tsserver can resolve them from the
            # workspace or runtime environment.
            "@styled/typescript-styled-plugin"
            # Older styled-components plugin name for older TS setups:
            # "typescript-styled-plugin"
          ];
          tsserver_locale = "en";
          tsserver_max_memory = "auto";
          jsx_close_tag = {
            enable = false;
            filetypes = [
              "javascriptreact"
              "typescriptreact"
            ];
          };
        };
      };
    };
  };

  autoGroups = lib.mkIf typescriptToolsEnabled {
    typescript_tools_group = { };
  };

  autoCmd = lib.mkIf typescriptToolsEnabled [
    {
      event = "FileType";
      pattern = [
        "javascript"
        "javascriptreact"
        "typescript"
        "typescriptreact"
      ];
      group = "typescript_tools_group";
      callback.__raw = ''
        function(args)
          local function apply_typescript_maps(bufnr)
            local opts = function(desc)
              return { buffer = bufnr, desc = desc }
            end
            local map = function(mode, key, command, desc)
              vim.keymap.set(mode, key, function()
                if vim.fn.exists(":" .. command) == 2 then
                  vim.cmd(command)
                  return
                end
                vim.notify(command .. " is not ready yet", vim.log.levels.WARN)
              end, opts(desc))
            end

            map("n", "<leader>zi", "TSToolsAddMissingImports", "Add Missing Imports")
            map("n", "<leader>zf", "TSToolsFixAll", "Fix All")
            map("n", "<leader>zl", "TSToolsOpenTsserverLog", "Open tsserver Logs")
            map("n", "<leader>zm", "TSToolsRemoveUnused", "Remove Unused")
            map("n", "<leader>zo", "TSToolsOrganizeImports", "Organize Imports")
            map("n", "<leader>zn", "TSToolsRenameFile", "Rename File")
            map("n", "<leader>zs", "TSToolsGoToSourceDefinition", "Source Definition")
            map("n", "<leader>zt", "TSToolsSortImports", "Sort Imports")
            map("n", "<leader>zu", "TSToolsRemoveUnusedImports", "Remove Unused Imports")
            map("n", "<leader>zR", "TSToolsFileReferences", "File References")
          end

          apply_typescript_maps(args.buf)
          vim.api.nvim_create_autocmd("LspAttach", {
            buffer = args.buf,
            callback = function(ev)
              apply_typescript_maps(ev.buf)
            end,
          })
        end
      '';
    }
  ];

  userCommands = lib.mkIf typescriptToolsEnabled {
    TSToolsOpenTsserverLog = {
      command.__raw = ''
        function()
          local log_dir = vim.uv.os_tmpdir()
          local syntax_log = vim.fs.joinpath(log_dir, "tsserver_syntax.log")
          local semantic_log = vim.fs.joinpath(log_dir, "tsserver_semantic.log")
          local syntax_exists = vim.fn.filereadable(syntax_log) == 1
          local semantic_exists = vim.fn.filereadable(semantic_log) == 1

          if syntax_exists and semantic_exists then
            vim.cmd(string.format("tabnew %s", vim.fn.fnameescape(syntax_log)))
            vim.cmd(string.format("vsplit %s", vim.fn.fnameescape(semantic_log)))
            return
          end

          if syntax_exists then
            vim.cmd(string.format("tabnew %s", vim.fn.fnameescape(syntax_log)))
            return
          end

          if semantic_exists then
            vim.cmd(string.format("tabnew %s", vim.fn.fnameescape(semantic_log)))
            return
          end

          vim.notify(
            "No tsserver logs found. Use the debug profile or enable plugins.typescript-tools.settings.settings.tsserver_logs.",
            vim.log.levels.WARN
          )
        end
      '';
      desc = "Open TypeScript tsserver logs.";
    };
  };
}
