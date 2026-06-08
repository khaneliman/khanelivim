{
  config,
  inputs,
  lib,
  pkgs,
  self,
  system,
  ...
}:
let
  neotestSubprocessRuntimePatch = /* Lua */ ''
    local subprocess = require("neotest.lib").subprocess

    if not subprocess._khanelivim_runtime_patch then
      local add_paths_to_rtp = subprocess.add_paths_to_rtp

      subprocess.add_paths_to_rtp = function(paths)
        local filtered = {}
        local seen = {}

        local function add(path)
          if type(path) == "string" and path ~= "" and not seen[path] then
            table.insert(filtered, path)
            seen[path] = true
          end
        end

        for _, path in ipairs(paths or {}) do
          add(path)
        end

        local treesitter = vim.api.nvim_get_runtime_file("lua/nvim-treesitter/init.lua", false)[1]
        if treesitter then
          add((treesitter:gsub("/lua/nvim%-treesitter/init%.lua$", "")))
        end

        return add_paths_to_rtp(filtered)
      end

      subprocess._khanelivim_runtime_patch = true
      end
  '';
  neotestSubprocessRuntimePatchFn = /* Lua */ ''
    function()
      ${neotestSubprocessRuntimePatch}
    end
  '';
  luaList = values: "{ ${lib.concatMapStringsSep ", " builtins.toJSON values} }";
  neotestNixPackage = lib.attrByPath [ system "neotest-nix" ] null (
    inputs.neotest-nix.packages or { }
  );
  neotestNixEnabled = neotestNixPackage != null;
  junitConsoleStandalone = pkgs.fetchurl {
    url = "https://repo1.maven.org/maven2/org/junit/platform/junit-platform-console-standalone/6.0.3/junit-platform-console-standalone-6.0.3.jar";
    hash = "sha256-O6DWFQr3khShQR+eovvvhk7vaLaMiaF/ZywLib/506I=";
  };
  lazyAdapter =
    {
      name,
      module,
      filetypes,
      patterns ? [ ],
      rootPatterns ? [ ],
      rootFilePatterns ? [ ],
      packageJsonPatterns ? [ ],
      beforeRequire ? "nil",
      setup ? "nil",
      testPathIgnorePatterns ? [ ],
      testPathPatterns ? [ ],
    }:
    /* Lua */ ''
      (function()
        local spec = {
          name = "${name}",
          module = "${module}",
          filetypes = ${luaList filetypes},
          patterns = ${luaList patterns},
          root_patterns = ${luaList rootPatterns},
          root_file_patterns = ${luaList rootFilePatterns},
          package_json_patterns = ${luaList packageJsonPatterns},
          before_require = ${beforeRequire},
          setup = ${setup},
          test_path_ignore_patterns = ${luaList testPathIgnorePatterns},
          test_path_patterns = ${luaList testPathPatterns},
        }
        local filetypes = {}
        if spec.before_require then
          spec.before_require()
        end
        local module = require(spec.module)
        local adapter = spec.setup and spec.setup(module) or module
        local adapter_is_test_file = adapter.is_test_file

        for _, ft in ipairs(spec.filetypes) do
          filetypes[ft] = true
        end

        local function matches(path)
          local _, ft = pcall(vim.filetype.match, { filename = path })
          if ft and filetypes[ft] then
            return true
          end

          for _, pattern in ipairs(spec.patterns) do
            if path:match(pattern) then
              return true
            end
          end

          return false
        end

        local function root(path)
          if #spec.root_patterns > 0 then
            local marker = vim.fs.find(spec.root_patterns, { path = path, upward = true })[1]
            if marker then
              return vim.fs.dirname(marker)
            end
          end

          if #spec.root_file_patterns > 0 then
            local start = path
            if vim.fn.isdirectory(start) == 0 then
              start = vim.fs.dirname(start)
            end

            local dir = start
            while dir do
              local ok, entries = pcall(vim.fn.readdir, dir)
              if ok then
                for _, entry in ipairs(entries) do
                  for _, pattern in ipairs(spec.root_file_patterns) do
                    if entry:match(pattern) then
                      return dir
                    end
                  end
                end
              end

              local parent = vim.fs.dirname(dir)
              if not parent or parent == dir then
                break
              end
              dir = parent
            end
          end

          if #spec.root_patterns > 0 or #spec.root_file_patterns > 0 then
            return nil
          end

          if vim.fn.isdirectory(path) == 0 and matches(path) then
            return vim.fs.dirname(path)
          end

          return nil
        end

        local function matches_package_json(path)
          if #spec.package_json_patterns == 0 then
            return true
          end

          local project_root = root(path)
          if not project_root then
            return false
          end

          local package_json = vim.fs.joinpath(project_root, "package.json")
          local ok, content = pcall(require("neotest.lib").files.read, package_json)
          if not ok then
            return false
          end
          for _, pattern in ipairs(spec.package_json_patterns) do
            if content:match(pattern) then
              return true
            end
          end

          return false
        end

        adapter.name = spec.name
        adapter.is_test_file = function(path)
          for _, pattern in ipairs(spec.test_path_ignore_patterns) do
            if path:match(pattern) then
              return false
            end
          end

          if not root(path) then
            return false
          end

          if not matches_package_json(path) then
            return false
          end

          for _, pattern in ipairs(spec.test_path_patterns) do
            if path:match(pattern) then
              return true
            end
          end

          if not matches(path) then
            return false
          end
          return adapter_is_test_file(path)
        end

        return adapter
      end)()
    '';
  neotestAdapterPlugins =
    lib.optionals (config.plugins.treesitter.enable && config.plugins.neotest.enable)
      (
        with pkgs.vimPlugins;
        [
          self.packages.${system}.neotest-bun
          neotest-bash
          neotest-deno
          neotest-dotnet
          neotest-go
          neotest-java
          neotest-jest
          neotest-playwright
          neotest-plenary
          neotest-python
          neotest-zig
        ]
      );
in
{
  extraConfigLuaPre = lib.mkIf (
    config.plugins.neotest.enable && !config.plugins.lz-n.enable
  ) neotestSubprocessRuntimePatch;

  extraPlugins = lib.mkIf config.plugins.neotest.enable (
    (lib.optional neotestNixEnabled neotestNixPackage)
    ++ [
      self.packages.${system}.neotest-bun
      self.packages.${system}.neotest-catch2
    ]
    ++ neotestAdapterPlugins
  );

  plugins = {
    neotest = {
      # neotest documentation
      # See: https://github.com/nvim-neotest/neotest
      enable = true;
      lazyLoad = {
        settings = {
          before.__raw = neotestSubprocessRuntimePatchFn;
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
          (lazyAdapter {
            name = "neotest-catch2";
            module = "neotest-catch2";
            filetypes = [
              "c"
              "cpp"
            ];
            patterns = [
              "%.cc$"
              "%.cpp$"
              "%.cxx$"
              "%.hh$"
              "%.hpp$"
              "%.hxx$"
            ];
            rootPatterns = [
              "CMakeLists.txt"
              "meson.build"
            ];
            testPathIgnorePatterns = [ "/test/main%.cpp$" ];
            testPathPatterns = [ "/test/.+%.cpp$" ];
          })
        ]
        ++ lib.optionals neotestNixEnabled [
          (lazyAdapter {
            name = "neotest-nix";
            module = "neotest-nix";
            filetypes = [ "nix" ];
            patterns = [ "%.nix$" ];
            rootPatterns = [ "flake.nix" ];
            # discover_eval_checks evaluates the flake to surface generated
            # outputs. eval_outputs widens that beyond `checks` to also pick up
            # home-manager-style test derivations under legacyPackages.test-*.
            setup = /* Lua */ ''
              function(module)
                return module.setup({
                  discover_eval_checks = true,
                  eval_outputs = {
                    { attr = "checks" },
                    { attr = "legacyPackages", match = "^test%-" },
                  },
                })
              end
            '';
          })
        ]
        ++ lib.optionals config.plugins.rustaceanvim.enable [
          (lazyAdapter {
            name = "rustaceanvim.neotest";
            module = "rustaceanvim.neotest";
            filetypes = [ "rust" ];
            patterns = [ "%.rs$" ];
            rootPatterns = [ "Cargo.toml" ];
          })
        ]
        ++ lib.optionals (config.plugins.treesitter.enable && config.plugins.neotest.enable) [
          (lazyAdapter {
            name = "neotest-bun";
            module = "neotest-bun";
            filetypes = [
              "javascript"
              "javascriptreact"
              "typescript"
              "typescriptreact"
            ];
            patterns = [
              "%.spec%.js$"
              "%.spec%.jsx$"
              "%.spec%.ts$"
              "%.spec%.tsx$"
              "%.test%.js$"
              "%.test%.jsx$"
              "%.test%.ts$"
              "%.test%.tsx$"
            ];
            rootPatterns = [ "package.json" ];
          })
          (lazyAdapter {
            name = "neotest-bash";
            module = "neotest-bash";
            filetypes = [
              "bash"
              "sh"
            ];
            patterns = [
              "%.bats$"
              "%.sh$"
            ];
            rootPatterns = [
              ".git"
              "lib"
            ];
          })
          (lazyAdapter {
            name = "neotest-deno";
            module = "neotest-deno";
            filetypes = [
              "javascript"
              "javascriptreact"
              "typescript"
              "typescriptreact"
            ];
            patterns = [
              "[_%.]test%.cjs$"
              "[_%.]test%.cts$"
              "[_%.]test%.js$"
              "[_%.]test%.jsx$"
              "[_%.]test%.mjs$"
              "[_%.]test%.mts$"
              "[_%.]test%.ts$"
              "[_%.]test%.tsx$"
              "/test%.cjs$"
              "/test%.cts$"
              "/test%.js$"
              "/test%.jsx$"
              "/test%.mjs$"
              "/test%.mts$"
              "/test%.ts$"
              "/test%.tsx$"
            ];
            rootPatterns = [
              "deno.json"
              "deno.jsonc"
              "import_map.json"
            ];
          })
          (lazyAdapter {
            name = "neotest-dotnet";
            module = "neotest-dotnet";
            filetypes = [
              "cs"
              "fsharp"
              "vb"
            ];
            patterns = [
              "%.cs$"
              "%.fs$"
              "%.vb$"
            ];
            rootPatterns = [
              "global.json"
              "Directory.Build.props"
            ];
            rootFilePatterns = [
              "%.csproj$"
              "%.fsproj$"
              "%.sln$"
            ];
            setup = "function(module) return module({ dap = { args = { justMyCode = false } } }) end";
          })
          (lazyAdapter {
            name = "neotest-go";
            module = "neotest-go";
            filetypes = [ "go" ];
            patterns = [ "_test%.go$" ];
            rootPatterns = [
              "go.mod"
              "go.sum"
            ];
          })
          (lazyAdapter {
            name = "neotest-java";
            module = "neotest-java";
            filetypes = [ "java" ];
            patterns = [ "%.java$" ];
            rootPatterns = [
              "build.gradle"
              "build.gradle.kts"
              "gradlew"
              "mvnw"
              "pom.xml"
              "settings.gradle"
              "settings.gradle.kts"
            ];
            beforeRequire = ''
              function()
                require("neotest-java.context_holder").update_notification_shown = true
              end
            '';
            setup = ''
              function(module)
                return module({
                  junit_jar = "${junitConsoleStandalone}",
                  disable_update_notifications = true,
                })
              end
            '';
          })
          (lazyAdapter {
            name = "neotest-jest";
            module = "neotest-jest";
            filetypes = [
              "javascript"
              "javascriptreact"
              "typescript"
              "typescriptreact"
            ];
            patterns = [
              "__tests__"
              "%.e2e%-spec%.coffee$"
              "%.e2e%-spec%.js$"
              "%.e2e%-spec%.jsx$"
              "%.e2e%-spec%.ts$"
              "%.e2e%-spec%.tsx$"
              "%.integration%.coffee$"
              "%.integration%.js$"
              "%.integration%.jsx$"
              "%.integration%.ts$"
              "%.integration%.tsx$"
              "%.regression%.coffee$"
              "%.regression%.js$"
              "%.regression%.jsx$"
              "%.regression%.ts$"
              "%.regression%.tsx$"
              "%.spec%.coffee$"
              "%.spec%.js$"
              "%.spec%.jsx$"
              "%.spec%.ts$"
              "%.spec%.tsx$"
              "%.test%.coffee$"
              "%.test%.js$"
              "%.test%.jsx$"
              "%.test%.ts$"
              "%.test%.tsx$"
              "%.unit%.coffee$"
              "%.unit%.js$"
              "%.unit%.jsx$"
              "%.unit%.ts$"
              "%.unit%.tsx$"
            ];
            rootPatterns = [ "package.json" ];
            packageJsonPatterns = [
              "\"jest\""
              "\"@jest/"
              "\"ts-jest\""
            ];
          })
          (lazyAdapter {
            name = "neotest-playwright";
            module = "neotest-playwright";
            filetypes = [
              "javascript"
              "javascriptreact"
              "typescript"
              "typescriptreact"
            ];
            patterns = [
              "%.spec%.js$"
              "%.spec%.jsx$"
              "%.spec%.ts$"
              "%.spec%.tsx$"
              "%.test%.js$"
              "%.test%.jsx$"
              "%.test%.ts$"
              "%.test%.tsx$"
            ];
            rootPatterns = [
              "playwright.config.js"
              "playwright.config.ts"
            ];
            setup = "function(module) return module.adapter end";
          })
          (lazyAdapter {
            name = "neotest-plenary";
            module = "neotest-plenary";
            filetypes = [ "lua" ];
            patterns = [
              "_spec%.lua$"
              "_test%.lua$"
            ];
            rootPatterns = [
              ".luarc.json"
              "lua"
            ];
          })
          (lazyAdapter {
            name = "neotest-python";
            module = "neotest-python";
            filetypes = [ "python" ];
            patterns = [
              "_test%.py$"
              "test_.*%.py$"
            ];
            rootPatterns = [
              "mypy.ini"
              "pyproject.toml"
              "pytest.ini"
              "setup.py"
              "setup.cfg"
            ];
          })
          (lazyAdapter {
            name = "neotest-zig";
            module = "neotest-zig";
            filetypes = [ "zig" ];
            patterns = [ "%.zig$" ];
            rootPatterns = [ "build.zig" ];
          })
        ];
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
