{
  config,
  lib,
  self,
  system,
  ...
}:
{
  extraPlugins = lib.mkIf config.plugins.neotest.enable [
    self.packages.${system}.neotest-catch2
  ];

  plugins = {
    neotest = {
      # neotest documentation
      # See: https://github.com/nvim-neotest/neotest
      enable = true;
      lazyLoad = {
        settings = {
          keys = [
            {
              __unkeyed-1 = "<leader>tt";
              __unkeyed-3 = "<CMD>Neotest summary<CR>";
              desc = "Summary toggle";
            }
            {
              __unkeyed-1 = "<leader>dn";
              __unkeyed-3.__raw = ''
                function()
                  require("neotest").run.run_last({strategy = "dap"})
                end
              '';
              desc = "Debug (Last)";
            }
            {
              __unkeyed-1 = "<leader>ta";
              __unkeyed-3 = "<CMD>Neotest attach<CR>";
              desc = "Attach";
            }
            {
              __unkeyed-1 = "<leader>td";
              __unkeyed-3.__raw = ''
                function()
                  require("neotest").run.run({strategy = "dap"})
                end
              '';
              desc = "Debug";
            }
            {
              __unkeyed-1 = "<leader>th";
              __unkeyed-3 = "<CMD>Neotest output<CR>";
              desc = "Output";
            }
            {
              __unkeyed-1 = "<leader>to";
              __unkeyed-3 = "<CMD>Neotest output-panel<CR>";
              desc = "Output Panel toggle";
            }
            {
              __unkeyed-1 = "<leader>tr";
              __unkeyed-3 = "<CMD>Neotest run<CR>";
              desc = "Run (Nearest Test)";
            }
            {
              __unkeyed-1 = "<leader>tR";
              __unkeyed-3.__raw = ''
                function()
                  require("neotest").run.run(vim.fn.expand("%"))
                end
              '';
              desc = "Run (File)";
            }
            {
              __unkeyed-1 = "<leader>tl";
              __unkeyed-3.__raw = ''
                function()
                  require("neotest").run.run_last()
                end
              '';
              desc = "Run (Last)";
            }
            {
              __unkeyed-1 = "<leader>tf";
              __unkeyed-3.__raw = ''
                function()
                  local neotest = require("neotest")
                  neotest.jump.next({ status = "failed" })
                  neotest.run.run()
                end
              '';
              desc = "Run (Next Failed)";
            }
            {
              __unkeyed-1 = "]n";
              __unkeyed-3.__raw = ''
                function()
                  require("neotest").jump.next({ status = "failed" })
                end
              '';
              desc = "Next Failed Test";
            }
            {
              __unkeyed-1 = "[n";
              __unkeyed-3.__raw = ''
                function()
                  require("neotest").jump.prev({ status = "failed" })
                end
              '';
              desc = "Previous Failed Test";
            }
            {
              __unkeyed-1 = "<leader>ts";
              __unkeyed-3 = "<CMD>Neotest stop<CR>";
              desc = "Stop";
            }
          ];
        };
      };

      settings = {
        adapters = [
          # Catch2 adapter for C++ testing
          "require('neotest-catch2')"
        ]
        ++ lib.optionals config.plugins.rustaceanvim.enable [
          /* Lua */ "require('rustaceanvim.neotest')"
        ];
      };

      adapters = lib.mkIf (config.plugins.treesitter.enable && config.plugins.neotest.enable) {
        bash.enable = true;
        # FIXME: deno_fmt is currently broken
        # deno.enable = true;
        dotnet = {
          enable = true;

          settings = {
            dap = {
              args = {
                justMyCode = false;
              };
            };
          };
        };
        go.enable = true;
        java.enable = true;
        # NOTE: just run NeotestJava setup
        # java.settings = {
        # Not sure why this wasn't working
        # junit_jar =
        #   pkgs.fetchurl
        #     {
        #       url = "https://repo1.maven.org/maven2/org/junit/platform/junit-platform-console-standalone/1.10.1/junit-platform-console-standalone-1.10.1.jar";
        #       hash = "sha256-tC6qU9E1dtF9tfuLKAcipq6eNtr5X0JivG6W1Msgcl8=";
        #     }
        #     .outPath;
        # };
        jest.enable = true;
        playwright.enable = true;
        plenary.enable = true;
        python.enable = true;
        # rust.enable = true;
        zig.enable = true;
      };
    };

  };

  keymaps = lib.mkIf (config.plugins.neotest.enable && !config.plugins.lz-n.enable) [
    {
      mode = "n";
      key = "<leader>dn";
      action.__raw = ''
        function()
          require("neotest").run.run_last({strategy = "dap"})
        end
      '';
      options = {
        desc = "Debug (Last)";
      };
    }
    {
      mode = "n";
      key = "<leader>ta";
      action = "<CMD>Neotest attach<CR>";
      options = {
        desc = "Attach";
      };
    }
    {
      mode = "n";
      key = "<leader>td";
      action.__raw = ''
        function()
          require("neotest").run.run({strategy = "dap"})
        end
      '';
      options = {
        desc = "Debug";
      };
    }
    {
      mode = "n";
      key = "<leader>th";
      action = "<CMD>Neotest output<CR>";
      options = {
        desc = "Output";
      };
    }
    {
      mode = "n";
      key = "<leader>to";
      action = "<CMD>Neotest output-panel<CR>";
      options = {
        desc = "Output Panel toggle";
      };
    }
    {
      mode = "n";
      key = "<leader>tr";
      action = "<CMD>Neotest run<CR>";
      options = {
        desc = "Run (Nearest Test)";
      };
    }
    {
      mode = "n";
      key = "<leader>tR";
      action.__raw = ''
        function()
          require("neotest").run.run(vim.fn.expand("%"))
        end
      '';
      options = {
        desc = "Run (File)";
      };
    }
    {
      mode = "n";
      key = "<leader>tl";
      action.__raw = ''
        function()
          require("neotest").run.run_last()
        end
      '';
      options = {
        desc = "Run (Last)";
      };
    }
    {
      mode = "n";
      key = "<leader>tf";
      action.__raw = ''
        function()
          local neotest = require("neotest")
          neotest.jump.next({ status = "failed" })
          neotest.run.run()
        end
      '';
      options = {
        desc = "Run (Next Failed)";
      };
    }
    {
      mode = "n";
      key = "]n";
      action.__raw = ''
        function()
          require("neotest").jump.next({ status = "failed" })
        end
      '';
      options = {
        desc = "Next Failed Test";
      };
    }
    {
      mode = "n";
      key = "[n";
      action.__raw = ''
        function()
          require("neotest").jump.prev({ status = "failed" })
        end
      '';
      options = {
        desc = "Previous Failed Test";
      };
    }
    {
      mode = "n";
      key = "<leader>ts";
      action = "<CMD>Neotest stop<CR>";
      options = {
        desc = "Stop";
      };
    }
    {
      mode = "n";
      key = "<leader>tt";
      action = "<CMD>Neotest summary<CR>";
      options = {
        desc = "Summary toggle";
      };
    }
  ];
}
