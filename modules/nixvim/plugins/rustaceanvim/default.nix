{
  config,
  lib,
  pkgs,
  ...
}:
{
  extraPlugins = lib.mkIf config.plugins.rustaceanvim.enable (
    with pkgs.vimPlugins;
    [
      {
        plugin = webapi-vim;
        optional = true;
      }
    ]
  );

  plugins = {
    rustaceanvim = {
      # rustaceanvim documentation
      # See: https://github.com/mrcjkb/rustaceanvim
      enable = config.khanelivim.lsp.rust == "rustaceanvim";
      lazyLoad.settings = {
        ft = "rust";
        before.__raw = ''
          function()
            vim.cmd("packadd webapi-vim")
          end
        '';
      };
      settings = {
        dap = {
          adapter = {
            type = "server";
            port = "\${port}";
            executable = {
              command = "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb";
              args = [
                "--port"
                "\${port}"
              ];
            };
            name = "codelldb";
          };
          autoloadConfigurations = true;
        };

        server = {
          default_settings = {
            rust-analyzer = {
              cargo = {
                buildScripts.enable = true;
                features = "all";
              };

              diagnostics = {
                enable = true;
                styleLints.enable = true;
              };

              checkOnSave = true;
              check = {
                command = "clippy";
                features = "all";
              };

              files = {
                excludeDirs = [
                  ".cargo"
                  ".direnv"
                  ".git"
                  "node_modules"
                  "target"
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

              rustc.source = "discover";
            };
          };
        };
        tools.enable_clippy = true;
      };
    };

  };

  autoCmd = lib.mkIf config.plugins.rustaceanvim.enable [
    {
      event = "FileType";
      pattern = [ "rust" ];
      callback.__raw = ''
        function(args)
          local function apply_rust_maps(bufnr)
            local opts = function(desc)
              return { buffer = bufnr, desc = desc }
            end
            local map = function(mode, key, rust_lsp_cmd, desc)
              vim.keymap.set(mode, key, function()
                if vim.fn.exists(":RustLsp") == 2 then
                  vim.cmd("RustLsp " .. rust_lsp_cmd)
                  return
                end
                vim.notify("RustLsp command is not ready yet", vim.log.levels.WARN)
              end, opts(desc))
            end

            -- RUN / DEBUG
            map("n", "<leader>Rr", "runnables", "Rust Runnables")
            map("n", "<leader>RD", "debuggables", "Rust Debuggables")
            -- map("n", "<leader>RR", "run", "Run target at cursor")
            -- map("n", "<leader>DD", "debug", "Debug target at cursor")
            -- map("n", "<leader>Rt", "testables", "Rust Testables")
            -- map("n", "<leader>dc", "flyCheck run", "Rust FlyCheck Run")
            -- map("n", "<leader>dx", "flyCheck cancel", "Rust FlyCheck Cancel")
            -- map("n", "<leader>dX", "flyCheck clear", "Rust FlyCheck Clear")

            -- LSP / REFACTOR / TRANSFORM
            map({ "n", "x" }, "<leader>la", "codeAction", "Code Action (Rust)")
            map("n", "<leader>lh", "hover actions", "Hover Actions (Rust)")
            map("x", "<leader>lh", "hover range", "Hover Range (Rust)")
            map("n", "<leader>lm", "expandMacro", "Expand Macro")
            map("n", "<leader>lM", "rebuildProcMacros", "Rebuild Proc Macros")
            map("n", "<leader>lJ", "joinLines", "Join Lines")
            map("x", "<leader>lJ", "joinLines", "Join Lines (Selection)")
            -- map("n", "<leader>lu", "moveItem up", "Move Item Up")
            -- map("n", "<leader>ld", "moveItem down", "Move Item Down")
            map("n", "<leader>ls", "ssr", "Structural Search/Replace")
            map("x", "<leader>ls", "ssr", "Structural Search/Replace (Selection)")
            -- map("n", "<leader>lt", "relatedTests", "Related Tests")

            -- DIAGNOSTICS
            -- map("n", "<leader>le", "explainError", "Explain Error (Cycle)")
            -- map("n", "<leader>lE", "explainError current", "Explain Error (Current Line)")
            -- map("n", "<leader>lq", "renderDiagnostic", "Render Diagnostic (Cycle)")
            map("n", "<leader>lH", "renderDiagnostic current", "Render Diagnostic (Current Line)")
            -- map("n", "<leader>lr", "relatedDiagnostics", "Related Diagnostics")

            -- NAVIGATION / DOCS / WORKSPACE
            map("n", "<leader>sho", "openDocs", "Open Docs (Rust)")
            map("n", "<leader>lC", "openCargo", "Open Cargo.toml")
            map("n", "<leader>lG", "crateGraph", "Crate Graph")
            -- map("n", "<leader>lp", "parentModule", "Open Parent Module")
            -- map("n", "<leader>lS", "workspaceSymbol", "Workspace Symbol")
            -- map("n", "<leader>lT", "workspaceSymbol onlyTypes", "Workspace Types")
            -- map("n", "<leader>lA", "workspaceSymbol allSymbols", "Workspace All Symbols")
            -- map("n", "<leader>lW", "reloadWorkspace", "Reload Workspace")
            -- map("n", "<leader>lY", "syntaxTree", "Syntax Tree")
            -- map("n", "<leader>lV", "view hir", "View HIR")
            -- map("n", "<leader>lN", "view mir", "View MIR")
            -- map("n", "<leader>shO", "externalDocs", "Open External Docs")
            -- map("n", "<leader>slr", "logFile", "Open rust-analyzer Log")
          end

          -- Set immediately, then re-apply on LspAttach to override generic LSP maps.
          apply_rust_maps(args.buf)
          vim.api.nvim_create_autocmd("LspAttach", {
            buffer = args.buf,
            callback = function(ev)
              apply_rust_maps(ev.buf)
            end,
          })
        end
      '';
    }
  ];
}
