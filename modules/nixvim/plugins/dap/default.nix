{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    # FIXME: bashdb broken
    # ./bash.nix
    ./dotnet.nix
    ./godot.nix
    ./javascript.nix
    ./lua.nix
  ];

  extraPackages = lib.mkIf config.plugins.dap.enable (
    with pkgs;
    [
      coreutils
      lldb
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      gdb
    ]
  );

  plugins = {
    dap = {
      enable = lib.elem "dap" config.khanelivim.debugging.adapters;

      lazyLoad.settings = {
        # NOTE: Couldn't get lazy loading to work any other way...
        # Hate plugins that require this verbosity for lazy load
        keys = [
          {
            __unkeyed-1 = "<leader>db";
            __unkeyed-2.__raw = ''
              function() require('dap').toggle_breakpoint() end
            '';
            desc = "Breakpoint toggle";
          }
          {
            __unkeyed-1 = "<leader>dc";
            __unkeyed-2.__raw = ''
              function() require('dap').continue() end
            '';
            desc = "Continue Debugging (Start)";
          }
          {
            __unkeyed-1 = "<leader>dC";
            __unkeyed-2.__raw = ''
              function() require('dap').run_to_cursor() end
            '';
            desc = "Run to cursor";
          }
          {
            __unkeyed-1 = "<leader>dg";
            __unkeyed-2.__raw = ''
              function() require('dap').goto_() end
            '';
            desc = "Go to line (no execute)";
          }
          {
            __unkeyed-1 = "<leader>di";
            __unkeyed-2.__raw = ''
              function() require('dap').step_into() end
            '';
            desc = "Step Into";
          }
          {
            __unkeyed-1 = "<leader>dj";
            __unkeyed-2.__raw = ''
              function() require('dap').down() end
            '';
            desc = "Down";
          }
          {
            __unkeyed-1 = "<leader>dk";
            __unkeyed-2.__raw = ''
              function() require('dap').up() end
            '';
            desc = "Up";
          }
          {
            __unkeyed-1 = "<leader>dl";
            __unkeyed-2.__raw = ''
              function() require('dap').run_last() end
            '';
            desc = "Run Last";
          }
          {
            __unkeyed-1 = "<leader>do";
            __unkeyed-2.__raw = ''
              function() require('dap').step_out() end
            '';
            desc = "Step Out";
          }
          {
            __unkeyed-1 = "<leader>dO";
            __unkeyed-2.__raw = ''
              function() require('dap').step_over() end
            '';
            desc = "Step Over";
          }
          {
            __unkeyed-1 = "<leader>dp";
            __unkeyed-2.__raw = ''
              function() require('dap').pause() end
            '';
            desc = "Pause";
          }
          {
            __unkeyed-1 = "<leader>dr";
            __unkeyed-2.__raw = ''
              function() require('dap').repl.toggle() end
            '';
            desc = "Toggle REPL";
          }
          {
            __unkeyed-1 = "<leader>ds";
            __unkeyed-2.__raw = ''
              function() require('dap').session() end
            '';
            desc = "Session";
          }
          {
            __unkeyed-1 = "<leader>dt";
            __unkeyed-2.__raw = ''
              function() require('dap').terminate() end
            '';
            desc = "Terminate Debugging";
          }
        ];
      };

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
              # FIXME: brkoken in nixpkgs on darwin
              command = lib.mkIf pkgs.stdenv.hostPlatform.isLinux "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb";
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
          c = [
            lldb-config
          ]
          ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
            gdb-config
          ];

          cpp = [
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
          texthl = "DapBreakpointCondition";
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
        mode = [
          "n"
          "v"
        ];
        desc = "Debug";
        # icon = " ";
      }
    ];
  };

  keymaps = lib.optionals (config.plugins.dap.enable && !config.plugins.dap.lazyLoad.enable) [
    {
      mode = "n";
      key = "<leader>db";
      # action = "<CMD>DapToggleBreakpoint<CR>";
      action = "<CMD>lua require('dap').toggle_breakpoint()<CR>";
      options = {
        desc = "Breakpoint toggle";
      };
    }
    {
      mode = "n";
      key = "<leader>dc";
      # action = "<CMD>DapContinue<CR>";
      action = "<CMD>lua require('dap').continue()<CR>";
      options = {
        desc = "Continue Debugging (Start)";
      };
    }
    {
      mode = "n";
      key = "<leader>dC";
      action = "<CMD>lua require('dap').run_to_cursor()<CR>";
      options = {
        desc = "Run to cursor";
      };
    }
    {
      mode = "n";
      key = "<leader>dg";
      action = "<CMD>lua require('dap').goto_()<CR>";
      options = {
        desc = "Go to line (no execute)";
      };
    }
    {
      mode = "n";
      key = "<leader>di";
      # action = "<CMD>DapStepInto<CR>";
      action = "<CMD>lua require('dap').step_into()<CR>";
      options = {
        desc = "Step Into";
      };
    }
    {
      mode = "n";
      key = "<leader>dj";
      action = "<CMD>lua require('dap').down()<CR>";
      options = {
        desc = "Down";
      };
    }
    {
      mode = "n";
      key = "<leader>dk";
      action = "<CMD>lua require('dap').up()<CR>";
      options = {
        desc = "Up";
      };
    }
    {
      mode = "n";
      key = "<leader>dl";
      action = "<CMD>lua require('dap').run_last()<CR>";
      options = {
        desc = "Run Last";
      };
    }
    {
      mode = "n";
      key = "<leader>do";
      # action = "<CMD>DapStepOut<CR>";
      action = "<CMD>lua require('dap').step_out()<CR>";
      options = {
        desc = "Step Out";
      };
    }
    {
      mode = "n";
      key = "<leader>dO";
      # action = "<CMD>DapStepOver<CR>";
      action = "<CMD>lua require('dap').step_over()<CR>";
      options = {
        desc = "Step Over";
      };
    }
    {
      mode = "n";
      key = "<leader>dp";
      action = "<CMD>lua require('dap').pause()<CR>";
      options = {
        desc = "Pause";
      };
    }
    {
      mode = "n";
      key = "<leader>dr";
      # action = "<CMD>DapToggleRepl<CR>";
      action = "<CMD>lua require('dap').repl.toggle()<CR>";
      options = {
        desc = "Toggle REPL";
      };
    }
    {
      mode = "n";
      key = "<leader>ds";
      action = "<CMD>lua require('dap').session()<CR>";
      options = {
        desc = "Session";
      };
    }
    {
      mode = "n";
      key = "<leader>dt";
      # action = "<CMD>DapTerminate<CR>";
      action = "<CMD>lua require('dap').terminate()<CR>";
      options = {
        desc = "Terminate Debugging";
      };
    }
  ];
}
