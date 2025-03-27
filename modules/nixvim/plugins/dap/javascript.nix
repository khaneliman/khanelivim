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
          pwa-node = {
            host = "localhost";
            port = "\${port}";
            # port = 8123;
            executable = {
              command = lib.getExe pkgs.vscode-js-debug;
              args = [
                "\${port}"
                # "8123"
              ];
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
              type = "pwa-node";
              request = "attach";
              name = "Auto Attach";
              cwd.__raw = "vim.fn.getcwd()";
              protocol = "inspector";
              sourceMaps = true;
              resolveSourceMapLocations = [
                "\${workspaceFolder}/**"
                "!**/node_modules/**"
              ];
              restart = true;
            }

            {
              type = "pwa-node";
              request = "launch";
              name = "Debug Server (Production Build)";
              skipFiles = [
                "<node_internals>/**"
              ];
              program.__raw = "vim.fn.getcwd() .. '/build/server/index.js'";
              outFiles = [
                "\${workspaceFolder}/build/**/*.js"
              ];
              console = "integratedTerminal";
            }
            {
              type = "pwa-node";
              request = "launch";
              name = "Debug with Node Inspect";
              skipFiles = [
                "<node_internals>/**"
              ];
              runtimeExecutable = lib.getExe pkgs.nodejs;
              runtimeArgs = [
                "--inspect"
                "./build/server/index.js"
              ];
              console = "integratedTerminal";
              cwd = "\${workspaceFolder}";
              sourceMaps = true;
              resolveSourceMapLocations = [
                "\${workspaceFolder}/**"
                "!**/node_modules/**"
              ];
            }
            {
              type = "pwa-node";
              request = "launch";
              name = "Debug with Node Inspect (Break)";
              skipFiles = [
                "<node_internals>/**"
              ];
              runtimeExecutable = lib.getExe pkgs.nodejs;
              runtimeArgs = [
                "--inspect-brk"
                "./build/server/index.js"
              ];
              console = "integratedTerminal";
              cwd = "\${workspaceFolder}";
              sourceMaps = true;
              resolveSourceMapLocations = [
                "\${workspaceFolder}/**"
                "!**/node_modules/**"
              ];
            }
            {
              type = "pwa-node";
              request = "launch";
              name = "Debug Vite Dev Server";
              skipFiles = [
                "<node_internals>/**"
              ];
              runtimeExecutable = lib.getExe pkgs.nodejs;
              runtimeArgs = [
                "--inspect"
                "node_modules/vite/bin/vite.js"
                "--host"
              ];
              console = "integratedTerminal";
              cwd = "\${workspaceFolder}";
              sourceMaps = true;
              resolveSourceMapLocations = [
                "\${workspaceFolder}/**"
                "!**/node_modules/**"
              ];
            }
            {
              type = "pwa-node";
              request = "attach";
              name = "Attach to Process";
              port = 9229;
              restart = true;
              skipFiles = [
                "<node_internals>/**"
              ];
              sourceMaps = true;
              resolveSourceMapLocations = [
                "\${workspaceFolder}/**"
                "!**/node_modules/**"
              ];
              cwd = "\${workspaceFolder}";
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
