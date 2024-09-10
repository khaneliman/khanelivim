{
  config,
  lib,
  pkgs,
  ...
}:
let
  codelldb-config = {
    name = "Launch (CodeLLDB)";
    type = "codelldb";
    request = "launch";
    program.__raw = ''
      function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. '/', "file")
      end
    '';
    cwd = ''''${workspaceFolder}'';
    stopOnEntry = false;
  };

  coreclr-config = {
    type = "coreclr";
    name = "launch - netcoredbg";
    request = "launch";
    progra.__raw = ''
      function()
        if vim.fn.confirm('Should I recompile first?', '&yes\n&no', 2) == 1 then
          vim.g.dotnet_build_project()
        end

        return vim.g.dotnet_get_dll_path()
      end'';
    cwd = ''''${workspaceFolder}'';
  };

  netcoredb-config = coreclr-config;

  gdb-config = {
    name = "Launch (GDB)";
    type = "gdb";
    request = "launch";
    program.__raw = ''
      function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. '/', "file")
      end'';
    cwd = ''''${workspaceFolder}'';
    stopOnEntry = false;
  };

  lldb-config = {
    name = "Launch (LLDB)";
    type = "lldb";
    request = "launch";
    program.__raw = ''
      function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. '/', "file")
      end'';
    cwd = ''''${workspaceFolder}'';
    stopOnEntry = false;
  };

  sh-config = lib.mkIf pkgs.stdenv.isLinux {
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
  };
in
{
  extraPackages =
    with pkgs;
    [
      coreutils
      lldb
      netcoredbg
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      pkgs.gdb
      pkgs.bashdb
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
            command = lib.getExe' pkgs.lldb (if pkgs.stdenv.isLinux then "lldb-dap" else "lldb-vscode");
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
          codelldb = lib.mkIf pkgs.stdenv.isLinux {
            port = 13000;
            executable = {
              command = "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb";
              args = [
                "--port"
                "13000"
              ];
            };
          };
        };
      };

      configurations = {
        c = [ lldb-config ] ++ lib.optionals pkgs.stdenv.isLinux [ gdb-config ];

        cpp =
          [ lldb-config ]
          ++ lib.optionals pkgs.stdenv.isLinux [
            gdb-config
            codelldb-config
          ];

        cs = [
          coreclr-config
          netcoredb-config
        ];

        fsharp = [
          coreclr-config
          netcoredb-config
        ];

        rust =
          [ lldb-config ]
          ++ lib.optionals pkgs.stdenv.isLinux [
            gdb-config
            codelldb-config
          ];

        sh = lib.optionals pkgs.stdenv.isLinux [ sh-config ];
      };

      extensions = {
        dap-ui = {
          enable = true;
        };

        dap-virtual-text = {
          enable = true;
        };
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

    which-key.settings.spec = lib.optionals config.plugins.dap.extensions.dap-ui.enable [
      {
        __unkeyed = "<leader>d";
        mode = "n";
        desc = "Debug";
        # icon = " ";
      }
    ];
  };

  keymaps = lib.optionals config.plugins.dap.extensions.dap-ui.enable [
    {
      mode = "n";
      key = "<leader>db";
      action.__raw = ''
        function()
          require("dap").toggle_breakpoint()
        end
      '';
      options = {
        desc = "Breakpoint toggle";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>dc";
      action.__raw = ''
        function()
          require("dap").continue()
        end
      '';
      options = {
        desc = "Continue Debugging (Start)";
        silent = true;
      };
    }
    {
      mode = "v";
      key = "<leader>de";
      action.__raw = ''
        function() require("dapui").eval() end
      '';
      options = {
        desc = "Evaluate Input";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>de";
      action.__raw = ''
        function()
          vim.ui.input({ prompt = "Expression: " }, function(expr)
            if expr then require("dapui").eval(expr, { enter = true }) end
          end)
        end
      '';
      options = {
        desc = "Evaluate Input";
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
      action.__raw = ''
        function()
          require("dap").step_out()
        end
      '';
      options = {
        desc = "Step Out";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>ds";
      action.__raw = ''
        function()
          require("dap").step_over()
        end
      '';
      options = {
        desc = "Step Over";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>dS";
      action.__raw = ''
        function()
          require("dap").step_into()
        end
      '';
      options = {
        desc = "Step Into";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>dt";
      action.__raw = ''
        function() require("dap").terminate() end
      '';
      options = {
        desc = "Terminate Debugging";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>du";
      action.__raw = ''
        function()
          require('dap.ext.vscode').load_launchjs(nil, {})
          require("dapui").toggle()
        end
      '';
      options = {
        desc = "Toggle Debugger UI";
        silent = true;
      };
    }
  ];
}
