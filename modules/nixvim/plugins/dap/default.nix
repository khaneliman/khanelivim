{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./bash.nix
    ./dotnet.nix
    ./javascript.nix
  ];

  extraPackages =
    with pkgs;
    [
      coreutils
      lldb
    ]
    ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
      gdb
    ];

  extraPlugins = with pkgs.vimPlugins; [
    # nvim-gdb
    nvim-dap-vscode-js
  ];

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

      luaConfig.content = ''
        require("dap-vscode-js").setup({
          adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' },
          -- debugger_path = '${pkgs.vscode-js-debug}/lib/node_modules/js-debug',
          debugger_cmd = { '${lib.getExe pkgs.vscode-js-debug}' }
        })
      '';

      adapters = {
        executables = {
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
            ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
              gdb-config
            ];

          cpp =
            [
              codelldb-config
              lldb-config
            ]
            ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
              gdb-config
            ];

          rust = lib.mkIf (!config.plugins.rustaceanvim.enable) (
            [
              codelldb-config
              lldb-config
            ]
            ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
              gdb-config
            ]
          );
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
      key = "<leader>dC";
      action = "<cmd>lua require('dap').run_to_cursor()<cr>";
      options = {
        desc = "Run to cursor";
      };
    }
    {
      mode = "n";
      key = "<leader>dg";
      action = "<cmd>lua require('dap').goto_()<cr>";
      options = {
        desc = "Go to line (no execute)";
      };
    }
    {
      mode = "n";
      key = "<leader>di";
      action = "<CMD>DapStepInto<CR>";
      options = {
        desc = "Step Into";
      };
    }
    {
      mode = "n";
      key = "<leader>dj";
      action = "<cmd>lua require('dap').down()<cr>";
      options = {
        desc = "Down";
      };
    }
    {
      mode = "n";
      key = "<leader>dk";
      action = "<cmd>lua require('dap').up()<cr>";
      options = {
        desc = "Up";
      };
    }
    {
      mode = "n";
      key = "<leader>dl";
      action = "<cmd>lua require('dap').run_last()<cr>";
      options = {
        desc = "Run Last";
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
      key = "<leader>dO";
      action = "<CMD>DapStepOver<CR>";
      options = {
        desc = "Step Over";
      };
    }
    {
      mode = "n";
      key = "<leader>dp";
      action = "<cmd>lua require('dap').pause()<cr>";
      options = {
        desc = "Pause";
      };
    }
    {
      mode = "n";
      key = "<leader>dr";
      action = ":DapToggleRepl<cr>";
      options = {
        desc = "Toggle REPL";
      };
    }
    {
      mode = "n";
      key = "<leader>ds";
      action = "<cmd>lua require('dap').session()<cr>";
      options = {
        desc = "Session";
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
