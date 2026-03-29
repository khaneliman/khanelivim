{
  config,
  lib,
  pkgs,
  ...
}:
{
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

      # TODO: https://github.com/GustavEikaas/easy-dotnet.nvim?tab=readme-ov-file#nvim-dap-configuration
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
    };

    dap = lib.mkIf config.plugins.easy-dotnet.enable {
      luaConfig.pre = ''
        local debug_dll = nil

        require("easy-dotnet.netcoredbg").register_dap_variables_viewer()

        require("dap").listeners.before['event_terminated']['easy-dotnet'] = function()
          debug_dll = nil
        end

        local function rebuild_project(co, path)
          local spinner = require("easy-dotnet.ui-modules.spinner").new()
          spinner:start_spinner("Building")
          vim.fn.jobstart(string.format("dotnet build %s", path), {
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

        local function ensure_dll()
          if debug_dll ~= nil then
            return debug_dll
          end
          local dll = require("easy-dotnet").get_debug_dll()
          debug_dll = dll
          return dll
        end
      '';

      configurations =
        let
          coreclr-config = {
            type = "coreclr";
            name = "launch - netcoredbg";
            request = "launch";
            env.__raw = ''
              function()
                local dll = ensure_dll()
                local vars = require("easy-dotnet").get_environment_variables(dll.project_name, dll.relative_project_path)
                return vars or nil
              end
            '';
            program.__raw = ''
              function()
                local dll = ensure_dll()
                local co = coroutine.running()
                rebuild_project(co, dll.project_path)
                return dll.relative_dll_path
              end
            '';
            cwd.__raw = ''
              function()
                local dll = ensure_dll()
                return dll.relative_project_path
              end
            '';
          };
        in
        {
          cs = [
            coreclr-config
          ];

          fsharp = [
            coreclr-config
          ];
        };
    };
  };
}
