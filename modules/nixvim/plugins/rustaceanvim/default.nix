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

  keymaps = lib.mkIf config.plugins.rustaceanvim.enable [
    {
      mode = "n";
      key = "<leader>Rr";
      action = "<cmd>RustLsp runnables<CR>";
      options.desc = "Rust Runnables";
    }
    {
      mode = "n";
      key = "<leader>RD";
      action = "<cmd>RustLsp debuggables<CR>";
      options.desc = "Rust Debuggables";
    }
    {
      mode = "n";
      key = "<leader>Ra";
      action = "<cmd>RustLsp codeAction<CR>";
      options.desc = "Code Action (Rust)";
    }
    {
      mode = "n";
      key = "<leader>Rh";
      action = "<cmd>RustLsp hover actions<CR>";
      options.desc = "Hover Actions (Rust)";
    }
    {
      mode = "n";
      key = "<leader>Rm";
      action = "<cmd>RustLsp expandMacro<CR>";
      options.desc = "Expand Macro";
    }
    {
      mode = "n";
      key = "<leader>RM";
      action = "<cmd>RustLsp rebuildProcMacros<CR>";
      options.desc = "Rebuild Proc Macros";
    }
    {
      mode = "n";
      key = "<leader>Rd";
      action = "<cmd>RustLsp openDocs<CR>";
      options.desc = "Open Docs";
    }
    {
      mode = "n";
      key = "<leader>Rc";
      action = "<cmd>RustLsp openCargo<CR>";
      options.desc = "Open Cargo.toml";
    }
    {
      mode = "n";
      key = "<leader>Rg";
      action = "<cmd>RustLsp crateGraph<CR>";
      options.desc = "Crate Graph";
    }
  ];
}
