{
  config,
  lib,
  pkgs,
  self,
  system,
  ...
}:
{
  extraPackages = lib.mkIf config.plugins.easy-dotnet.enable [
    self.packages.${system}.easydotnet
  ];

  autoGroups = lib.mkIf config.plugins.easy-dotnet.enable {
    easy_dotnet_group = { };
  };

  autoCmd = lib.mkIf config.plugins.easy-dotnet.enable [
    {
      event = "FileType";
      pattern = [
        "cs"
        "fsharp"
      ];
      group = "easy_dotnet_group";
      callback.__raw = ''
        function(args)
          local function apply_easy_dotnet_maps(bufnr)
            local opts = function(desc)
              return { buffer = bufnr, desc = desc }
            end
            local map = function(mode, key, command, desc)
              vim.keymap.set(mode, key, function()
                if command == "debug" and vim.bo[bufnr].filetype == "fsharp" then
                  require("dap").continue()
                  return
                end
                if vim.fn.exists(":Dotnet") == 2 then
                  vim.cmd("Dotnet " .. command)
                  return
                end
                vim.notify("Dotnet command is not ready yet", vim.log.levels.WARN)
              end, opts(desc))
            end

            map("n", "<leader>zb", "build", ".NET Build")
            map("n", "<leader>zd", "debug", ".NET Debug")
            map("n", "<leader>zD", "diagnostic", ".NET Diagnostics")
            map("n", "<leader>ze", "diagnostic errors", ".NET Diagnostic Errors")
            map("n", "<leader>zo", "outdated", ".NET Outdated Packages")
            map("n", "<leader>zr", "run", ".NET Run")
            map("n", "<leader>zt", "testrunner", ".NET Test Runner")
            map("n", "<leader>zW", "diagnostic warnings", ".NET Diagnostic Warnings")
            map("n", "<leader>zw", "watch", ".NET Watch")
          end

          apply_easy_dotnet_maps(args.buf)
          if vim.b[args.buf].khanelivim_easy_dotnet_lsp_attach_maps then
            return
          end
          vim.b[args.buf].khanelivim_easy_dotnet_lsp_attach_maps = true
          vim.api.nvim_create_autocmd("LspAttach", {
            buffer = args.buf,
            callback = function(ev)
              apply_easy_dotnet_maps(ev.buf)
            end,
          })
        end
      '';
    }
  ];

  plugins = {
    easy-dotnet = {
      # easy-dotnet.nvim documentation
      # See: https://github.com/GustavEikaas/easy-dotnet.nvim
      enable = lib.mkDefault true;

      lazyLoad.settings = {
        before.__raw = ''
          function()
            require("lz.n").trigger_load("nvim-dap")
          end
        '';
        ft = [
          "cs"
          "fsharp"
          "xml"
        ];
      };

      settings = {
        picker =
          if config.plugins.snacks.enable then
            "snacks"
          else if config.plugins.fzf-lua.enable then
            "fzf"
          else
            null;
        debugger.bin_path = lib.getExe pkgs.netcoredbg;
      };

      luaConfig.post = ''
        local dap = require("dap")
        local debug_dll = nil

        dap.adapters.coreclr = dap.adapters.coreclr or {
          type = "executable",
          command = "${lib.getExe pkgs.netcoredbg}",
          args = { "--interpreter=vscode" },
        }

        dap.listeners.before['event_terminated']['easy-dotnet-fsharp'] = function()
          debug_dll = nil
        end

        local function rebuild_project(path)
          local co = coroutine.running()
          if co == nil then
            error("F# DAP build must run inside a coroutine")
          end

          local spinner = require("easy-dotnet.ui-modules.spinner").new()
          local build_error = nil
          spinner:start_spinner("Building")
          local job = vim.fn.jobstart({ "dotnet", "build", path }, {
            on_exit = function(_, return_code)
              if return_code == 0 then
                spinner:stop_spinner("Built successfully")
              else
                build_error = "Build failed with exit code " .. return_code
                spinner:stop_spinner(build_error, vim.log.levels.ERROR)
              end

              local ok, resume_error = coroutine.resume(co)
              if not ok then
                vim.notify(
                  "Failed to resume F# DAP build: " .. tostring(resume_error),
                  vim.log.levels.ERROR
                )
              end
            end,
          })

          if job <= 0 then
            spinner:stop_spinner("Failed to start dotnet build", vim.log.levels.ERROR)
            error("Failed to start dotnet build")
          end

          coroutine.yield()
          if build_error ~= nil then
            error(build_error)
          end
        end

        local function trim(value)
          return value and value:match("^%s*(.-)%s*$") or nil
        end

        local function first_target_framework(target_framework, target_frameworks)
          target_framework = trim(target_framework)
          if target_framework and target_framework ~= "" then
            return target_framework
          end

          target_frameworks = trim(target_frameworks)
          if target_frameworks and target_frameworks ~= "" then
            return trim(vim.split(target_frameworks, ";", { plain = true })[1])
          end

          return nil
        end

        local function get_project_metadata_from_msbuild(project_path)
          local output = vim.fn.system({
            "dotnet",
            "msbuild",
            project_path,
            "-getProperty:TargetFramework",
            "-getProperty:TargetFrameworks",
            "-getProperty:AssemblyName",
            "-nologo",
          })
          if vim.v.shell_error ~= 0 or output == "" then
            return nil
          end

          local ok, metadata = pcall(vim.json.decode, output)
          local properties = ok and metadata and metadata.Properties or nil
          if type(properties) ~= "table" then
            return nil
          end

          local target_framework = first_target_framework(
            properties.TargetFramework,
            properties.TargetFrameworks
          )
          if not target_framework or target_framework == "" then
            return nil
          end

          return {
            assembly_name = trim(properties.AssemblyName)
              or vim.fn.fnamemodify(project_path, ":t:r"),
            target_framework = target_framework,
          }
        end

        local function get_project_metadata_from_xml(project_path)
          local xml = table.concat(vim.fn.readfile(project_path), "\n")
          local target_framework = first_target_framework(
            xml:match("<TargetFramework>([^<]+)</TargetFramework>"),
            xml:match("<TargetFrameworks>([^<]+)</TargetFrameworks>")
          )

          if not target_framework or target_framework == "" then
            error("Unable to determine TargetFramework for " .. project_path)
          end

          return {
            assembly_name = trim(xml:match("<AssemblyName>([^<]+)</AssemblyName>")) or vim.fn.fnamemodify(project_path, ":t:r"),
            target_framework = target_framework,
          }
        end

        local function get_project_metadata(project_path)
          return get_project_metadata_from_msbuild(project_path)
            or get_project_metadata_from_xml(project_path)
        end

        local function ensure_dll()
          if debug_dll ~= nil then
            return debug_dll
          end

          local bufname = vim.api.nvim_buf_get_name(0)
          local start_dir = bufname ~= "" and vim.fs.dirname(bufname) or vim.fn.getcwd()
          local project_path = vim.fs.find(function(name)
            return name:match("%.fsproj$") ~= nil
          end, { path = start_dir, upward = true, limit = 1 })[1]

          if not project_path then
            error("No .fsproj found for current buffer")
          end

          local project_dir = vim.fs.dirname(project_path)
          local metadata = get_project_metadata(project_path)
          local dll = {
            project_path = project_path,
            project_dir = project_dir,
            dll_path = table.concat({
              project_dir,
              "bin",
              "Debug",
              metadata.target_framework,
              metadata.assembly_name .. ".dll",
            }, "/"),
          }
          debug_dll = dll
          return dll
        end

        dap.configurations.fsharp = {
          {
            type = "coreclr",
            name = "launch - netcoredbg",
            request = "launch",
            program = function()
              local dll = ensure_dll()
              rebuild_project(dll.project_path)
              return dll.dll_path
            end,
            cwd = function()
              local dll = ensure_dll()
              return dll.project_dir
            end,
          },
        }
      '';
    };
  };
}
