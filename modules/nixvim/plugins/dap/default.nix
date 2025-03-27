{
  config,
  lib,
  pkgs,
  ...
}:
{
  extraPackages =
    with pkgs;
    [
      coreutils
      lldb
      netcoredbg
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      gdb
      bashdb
    ];

  #   extraPlugins = with pkgs.vimPlugins; [ nvim-gdb ];

  globals = {
    dotnet_build_project.__raw = ''
      function()
        local default_path = vim.fn.getcwd() .. '/'

        if vim.g['dotnet_last_proj_path'] ~= nil then
            default_path = vim.g['dotnet_last_proj_path']
        end

        local path = vim.fn.input('Path to your *proj file', default_path, 'file')

        vim.g['dotnet_last_proj_path'] = path

        local cmd = 'dotnet build -c Debug ' .. path .. ' > /dev/null'

        print("")
        print('Cmd to execute: ' .. cmd)

        local f = os.execute(cmd)

        if f == 0 then
            print('\nBuild: ✔️ ')
        else
            print('\nBuild: ❌ (code: ' .. f .. ')')
        end
      end
    '';

    dotnet_get_dll_path.__raw = ''
      function()
        local request = function()
            return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
        end

        if vim.g['dotnet_last_dll_path'] == nil then
            vim.g['dotnet_last_dll_path'] = request()
        else
            if vim.fn.confirm('Do you want to change the path to dll?\n' .. vim.g['dotnet_last_dll_path'], '&yes\n&no', 2) == 1 then
                vim.g['dotnet_last_dll_path'] = request()
            end
        end

        return vim.g['dotnet_last_dll_path']
      end
    '';
  };

  plugins = {
    dap = {
      enable = true;

      lazyLoad.settings = {
        cmd = [
          "DapContinue"
          "DapNew"
          "DapToggleBreakpoint"
        ];
      };

      adapters = {
        executables = {
          bashdb = lib.mkIf pkgs.stdenv.isLinux { command = lib.getExe pkgs.bashdb; };

          cppdbg = {
            command = "gdb";
            args = [
              "-i"
              "dap"
            ];
          };

          gdb = {
            command = "gdb";
            args = [
              "-i"
              "dap"
            ];
          };

          lldb = {
            command = lib.getExe' pkgs.lldb "lldb-dap";
          };

          coreclr = {
            command = lib.getExe pkgs.netcoredbg;
            args = [ "--interpreter=vscode" ];
          };

          netcoredbg = {
            command = lib.getExe pkgs.netcoredbg;
            args = [ "--interpreter=vscode" ];
          };
        };

        servers = {
          codelldb = {
            port = 13000;
            executable = {
              command = "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb";
              args = [
                "--port"
                "13000"
              ];
            };
          };
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
          program.__raw = ''
            function()
                return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. '/', "file")
            end
          '';

          codelldb-config = {
            inherit program;
            name = "Launch (CodeLLDB)";
            type = "codelldb";
            request = "launch";
            cwd = ''''${workspaceFolder}'';
            stopOnEntry = false;
          };

          coreclr-config = {
            type = "coreclr";
            name = "launch - netcoredbg";
            request = "launch";
            program.__raw = ''
              function()
                if vim.fn.confirm('Should I recompile first?', '&yes\n&no', 2) == 1 then
                  vim.g.dotnet_build_project()
                end

                return vim.g.dotnet_get_dll_path()
              end
            '';
            cwd = ''''${workspaceFolder}'';
          };

          gdb-config = {
            inherit program;
            name = "Launch (GDB)";
            type = "gdb";
            request = "launch";
            cwd = ''''${workspaceFolder}'';
            stopOnEntry = false;
          };

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
          ];

          lldb-config = {
            inherit program;
            name = "Launch (LLDB)";
            type = "lldb";
            request = "launch";
            cwd = ''''${workspaceFolder}'';
            stopOnEntry = false;
          };

          netcoredb-config = coreclr-config;
        in
        {
          c =
            [
              lldb-config
            ]
            ++ lib.optionals pkgs.stdenv.isLinux [
              gdb-config
            ];

          cpp =
            [
              codelldb-config
              lldb-config
            ]
            ++ lib.optionals pkgs.stdenv.isLinux [
              gdb-config
            ];

          cs = [
            coreclr-config
            netcoredb-config
          ];

          fsharp = [
            coreclr-config
            netcoredb-config
          ];

          javascript = javascript-config;
          javascriptreact = javascript-config;

          rust = lib.mkIf (!config.plugins.rustaceanvim.enable) (
            [
              codelldb-config
              lldb-config
            ]
            ++ lib.optionals pkgs.stdenv.isLinux [
              gdb-config
            ]
          );

          sh = lib.optionals pkgs.stdenv.isLinux [
            {
              type = "bashdb";
              request = "launch";
              name = "Launch (BashDB)";
              showDebugOutput = true;
              pathBashdb = "${lib.getExe pkgs.bashdb}";
              pathBashdbLib = "${pkgs.bashdb}/share/basdhb/lib/";
              trace = true;
              file = ''''${file}'';
              program = ''''${file}'';
              cwd = ''''${workspaceFolder}'';
              pathCat = "cat";
              pathBash = "${lib.getExe pkgs.bash}";
              pathMkfifo = "mkfifo";
              pathPkill = "pkill";
              args = { };
              env = { };
              terminalKind = "integrated";
            }
          ];

          typescript = javascript-config;
          typescriptreact = javascript-config;
        };

      signs = {
        dapBreakpoint = {
          text = "";
          texthl = "DapBreakpoint";
        };
        dapBreakpointCondition = {
          text = "";
          texthl = "dapBreakpointCondition";
        };
        dapBreakpointRejected = {
          text = "";
          texthl = "DapBreakpointRejected";
        };
        dapLogPoint = {
          text = "";
          texthl = "DapLogPoint";
        };
        dapStopped = {
          text = "";
          texthl = "DapStopped";
        };
      };
    };
    dap-go = {
      enable = true;
      settings.delve.path = "${lib.getExe pkgs.delve}";
    };
    dap-python.enable = true;

    which-key.settings.spec = lib.optionals config.plugins.dap.enable [
      {
        __unkeyed-1 = "<leader>d";
        mode = "n";
        desc = "Debug";
        # icon = " ";
      }
    ];
  };

  keymaps = lib.optionals config.plugins.dap.enable [
    {
      mode = "n";
      key = "<leader>db";
      action = "<CMD>DapToggleBreakpoint<CR>";
      options = {
        desc = "Breakpoint toggle";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>dc";
      action = "<CMD>DapContinue<CR>";
      options = {
        desc = "Continue Debugging (Start)";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>dh";
      action.__raw = ''
        function() require("dap.ui.widgets").hover() end
      '';
      options = {
        desc = "Debugger Hover";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>do";
      action = "<CMD>DapStepOut<CR>";
      options = {
        desc = "Step Out";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>ds";
      action = "<CMD>DapStepOver<CR>";
      options = {
        desc = "Step Over";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>dS";
      action = "<CMD>DapStepInto<CR>";
      options = {
        desc = "Step Into";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>dt";
      action = "<CMD>DapTerminate<CR>";
      options = {
        desc = "Terminate Debugging";
        silent = true;
      };
    }
  ];
}
