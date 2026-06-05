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
      enable = true;

      lazyLoad.settings.ft = [
        "cs"
        "fsharp"
        "xml"
      ];

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

        local function rebuild_project(co, path)
          local spinner = require("easy-dotnet.ui-modules.spinner").new()
          spinner:start_spinner("Building")
          vim.fn.jobstart({ "dotnet", "build", path }, {
            on_exit = function(_, return_code)
              if return_code == 0 then
                spinner:stop_spinner("Built successfully")
              else
                spinner:stop_spinner("Build failed with exit code " .. return_code, vim.log.levels.ERROR)
                error("Build failed")
              end
              coroutine.resume(co)
            end,
          })
          coroutine.yield()
        end

        local function trim(value)
          return value and value:match("^%s*(.-)%s*$") or nil
        end

        local function get_project_metadata(project_path)
          local xml = table.concat(vim.fn.readfile(project_path), "\n")
          local target_framework = trim(xml:match("<TargetFramework>([^<]+)</TargetFramework>"))
          local target_frameworks = trim(xml:match("<TargetFrameworks>([^<]+)</TargetFrameworks>"))
          if not target_framework and target_frameworks then
            target_framework = trim(vim.split(target_frameworks, ";", { plain = true })[1])
          end

          if not target_framework or target_framework == "" then
            error("Unable to determine TargetFramework for " .. project_path)
          end

          return {
            assembly_name = trim(xml:match("<AssemblyName>([^<]+)</AssemblyName>")) or vim.fn.fnamemodify(project_path, ":t:r"),
            target_framework = target_framework,
          }
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
              local co = coroutine.running()
              rebuild_project(co, dll.project_path)
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
