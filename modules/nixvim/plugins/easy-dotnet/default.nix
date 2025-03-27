{
  plugins.easy-dotnet = {
    enable = true;

    lazyLoad.settings.ft = [
      "cs"
      "fsharp"
      "xml"
    ];

    # TODO: https://github.com/GustavEikaas/easy-dotnet.nvim?tab=readme-ov-file#nvim-dap-configuration
    settings = {
      picker = "fzf";
    };
  };

  extraConfigLua = ''
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
  '';
}
