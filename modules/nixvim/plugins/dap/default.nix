{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./dotnet.nix
  ];

  extraPackages =
    with pkgs;
    [
      coreutils
      lldb
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      gdb
      bashdb
    ];

  #   extraPlugins = with pkgs.vimPlugins; [ nvim-gdb ];

  plugins = {
    dap = {
      enable = true;

      # lazyLoad.settings = {
      #   before.__raw = ''
      #     function()
      #       require('lz.n').trigger_load('nvim-dap-ui')
      #       require('lz.n').trigger_load('nvim-dap-virtual-text')
      #     end
      #   '';
      #   cmd = [
      #     "DapContinue"
      #     "DapNew"
      #     "DapToggleBreakpoint"
      #   ];
      # };

      luaConfig.pre = ''
        -- DEBUG LISTENERS
        require("dap").listeners.before.attach.dapui_config = function()
          require("dapui").open()
        end
        require("dap").listeners.before.launch.dapui_config = function()
          require("dapui").open()
        end
        require("dap").listeners.before.event_terminated.dapui_config = function()
          require("dapui").close()
        end
        require("dap").listeners.before.event_exited.dapui_config = function()
          require("dapui").close()
        end
      '';

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
