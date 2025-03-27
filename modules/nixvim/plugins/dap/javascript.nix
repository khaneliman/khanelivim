{
  lib,
  pkgs,
  ...
}:
{

  plugins = {
    dap = {
      adapters = {
        servers = {
          "pwa-node" = {
            host = "localhost";
            port = 8123;
            executable = {
              command = "${pkgs.vscode-js-debug}/bin/js-debug";
            };
          };
        };
      };

      configurations =
        let
          javascript-config = [
            {
              type = "pwa-node";
              request = "launch";
              name = "Launch file";
              program = "\${file}";
              cwd = "\${workspaceFolder}";
            }
            {
              type = "pwa-node";
              request = "attach";
              name = "Attach";
              processId.__raw = ''require ("dap.utils").pick_process'';
              cwd = "\${workspaceFolder}";
            }
            {
              type = "pwa-chrome";
              request = "launch";
              name = "Start Chrome with \"localhost\"";
              url = "http://localhost:3000";
              webRoot = "\${workspaceFolder}";
              userDataDir = "\${workspaceFolder}/.vscode/vscode-chrome-debug-userdatadir";
            }
            {
              type = "pwa-node";
              request = "attach";
              name = "Auto Attach";
              cwd.__raw = "vim.fn.getcwd()";
              protocol = "inspector";
            }
          ];
        in
        {
          javascript = javascript-config;
          javascriptreact = javascript-config;
          typescript = javascript-config;
          typescriptreact = javascript-config;
        };
    };
  };
}
